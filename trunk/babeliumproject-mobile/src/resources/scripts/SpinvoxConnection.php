<?php

class SpinvoxConnection {
	
	private $response;
	private $response_meta_info;
	
	private $url;
	private $username;
	private $password;
	private $appname;
	private $accountId;
	private $useragent;
	private $tmpFolder;
	
	/**
	 * Constructor
	 *
	 * @param $url Request URL
	 * @param $user
	 * @param $pass
	 * @param $appname
	 * @param $accountId
	 * @param $useragent
	 * @param $ffmpegPath
	 */
	public function __construct($url, $user, $pass, $appname, $accountId, $useragent, $tempFolder = "/tmp") {
		$this->url = $url;
		$this->username = $user;
		$this->password = $pass;
		$this->appname = $appname;
		$this->accountId = $accountId;
		$this->useragent = $useragent;
		$this->tmpFolder = $tempFolder;
	}
	
	/**
	 *
	 * Sends a conversion request to the Spinvox server
	 *
	 * @param $filePath The file that will be converted to WAV and sent for conversion.
	 * @param $refnumber A reference number for the SpinVox conversion. It can't be the same as the ones of previus conversions.
	 * @return an associative array with the location url of the conversion, the x-error, the x-reference, error code and date.
	 */
	public function transcript($filePath, $refnumber, $language = null) {
		$wavfile = $this->tmpFolder . "/" . $refnumber . ".wav";
		
		if (file_exists($filePath)) {
			$this->convertToAlaw($filePath, $wavfile);
			if (!file_exists($wavfile)) {
				echo "Error: Not converted to Alaw";
				return;
			}
		} else {
			echo "The file $filePath does not exist";
			return;
		}
		
		$refnumber = $refnumber;
		$mimeboundary = $this->generateMIMEBoundary($refnumber);
		$request = $this->buildPostData($this->accountId, $this->appname, $refnumber, $this->encodeFile($wavfile), $mimeboundary, $language = null);
		
		unlink($wavfile);
		
		$this->response_meta_info = array();
		
		$head[] = "Expect:";
		$head[] = "Connection:keep-alive";
		$head[] = "User-Agent: " . $this->useragent;
		$head[] = "Pragma: no-cache";
		$head[] = "Cache-Control: no-cache";
		$head[] = "Content-Type: multipart/mixed;boundary=" . $mimeboundary;
		$head[] = "MIME-Version: 1.0";
		
		//initiate curl transfer
		$ch = curl_init();
		
		//set the URL to connect to
		curl_setopt($ch, CURLOPT_URL, $this->url);
		
		//do not include headers in the response
		curl_setopt($ch, CURLOPT_HEADER, 0);
		
		//register a callback function which will process the headers
		//this assumes your code is into a class method, and uses $this->readHeader as the callback //function
		curl_setopt($ch, CURLOPT_HEADERFUNCTION, array(&$this, 'readHeader'));
		
		//Some servers (like Lighttpd) will not process the curl request without this header and will return error code 417 instead.
		//Apache does not need it, but it is safe to use it there as well.
		curl_setopt($ch, CURLOPT_HTTPHEADER, $head);
		
		//Response will be read in chunks of 64000 bytes
		curl_setopt($ch, CURLOPT_BUFFERSIZE, 64000);
		
		//Tell curl to use POST
		curl_setopt($ch, CURLOPT_POST, 1);
		
		//Tell curl to write the response to a variable
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
		
		//Register the data to be submitted via POST
		curl_setopt($ch, CURLOPT_POSTFIELDS, $request);
		
		curl_setopt($ch, CURLOPT_HTTPAUTH, CURLAUTH_DIGEST);
		curl_setopt($ch, CURLOPT_USERPWD, $this->username . ':' . $this->password);
		
		//Execute request
		$response = curl_exec($ch);
		
		//get the default response headers
		$headers = curl_getinfo($ch);
		
		//add the headers from the custom headers callback function
		$this->response_meta_info = array_merge($headers, $this->response_meta_info);
		
		//close connection
		curl_close($ch);
		
		//catch the case where no response is actually returned
		//but curl_exec returns true (on no data) or false (if cannot connect)
		if (is_bool($response))
			if (!$response) {
				echo "Error: No connection";
				return;
			} else {
				echo "Error: No data";
				return;
			}
		
		$data = array();
		$data['location'] = $this->response_meta_info['location'];
		$data['x_error'] = $this->response_meta_info['x_error'];
		$data['x_reference'] = $this->response_meta_info['x_reference'];
		$data['error_code'] = $this->response_meta_info['error_code'];
		$timestamp = strtotime($this->response_meta_info['date']);
		$data['date'] = date('Y-m-d H:i:s', $timestamp);
		
		return $data;
	}
	
	/**
	 * CURL callback function for reading and processing headers
	 *
	 * @param $ch
	 * @param $header
	 * @return integer
	 */
	private function readHeader($ch, $header) {
		//Extract conversion location from header
		$location = $this->extractCustomHeader('Location:', '\n', $header);
		if ($location) {
			$this->response_meta_info['location'] = trim($location);
		}
		//Extract x-reference from header
		$x_reference = $this->extractCustomHeader('X-Reference:', '\n', $header);
		if ($x_reference) {
			$this->response_meta_info['x_reference'] = trim($x_reference);
		}
		//Extract x-error from header
		$x_error = $this->extractCustomHeader('X-Error:', '\n', $header);
		if ($x_error) {
			$this->response_meta_info['x_error'] = trim($x_error);
		}
		//Extract error code from header
		$errorCode = $this->extractCustomHeader("HTTP\/1.1 ", '[ \n]', $header);
		if ($errorCode) {
			$this->response_meta_info['error_code'] = trim($errorCode);
		}
		//Extract data from header
		$date = $this->extractCustomHeader('Date:', '\n', $header);
		if ($date) {
			$this->response_meta_info['date'] = trim($date);
		}
		return strlen($header);
	}
	
	private function extractCustomHeader($start, $end, $header) {
		$result = "";
		$pattern = '/' . $start . '(.*?)' . $end . '/';
		if (preg_match($pattern, $header, $result)) {
			return $result[1];
		} else {
			return false;
		}
	}
	
	/**
	 * Encodes a file in base64
	 *
	 * @param $filepath The path of the file to encode
	 */
	private function encodeFile($filepath) {
		return base64_encode(file_get_contents($filepath));
	}
	
	/**
	 * Builds the data that is going to be sent in the POST request
	 *
	 * @param $accountId SpinVox account ID
	 * @param $appName SpinVox application name
	 * @param $refNumber The refference number of the request
	 * @param $encodedAudio The audio thas is going to be sent to SpinVox encoded in base64
	 * @param $mimeboundary
	 * @param $language The language of the audio file
	 * @return string
	 */
	private function buildPostData($accountId, $appName, $refNumber, $encodedAudio, $mimeboundary, $language = null) {
		$xml = "<?xml version=\"1.0\" ?>\n<request>\n<account-id>$accountId</account-id>\n<reference>$refNumber</reference>\n<app-name>$appName</app-name>\n";
		if($language)
			$xml = $xml . "<language>$language</language>\n";
		$xml = $xml . "</request>\n";
		return "--" . $mimeboundary . "\n" . "Content-Type: text/xml\n" . "Content-Length: " . strlen($xml) . "\n\n" . $xml . "\n" . "--" . $mimeboundary . "\n" . "Content-Type: audio/wav\n" . "Content-Transfer-Encoding: base64\n" . "Content-Length: " . strlen($encodedAudio) . "\n\n" . $encodedAudio . "\n" . "--" . $mimeboundary . "--\n\n";
	}
	
	private function generateMIMEBoundary($refnumber) {
		return $refnumber . "------" . md5(time());
	}
	
	/**
	 * Sends a retrieval request to the SpinVox URL where the conversion is located.
	 *
	 * @param $url The url where the conversion is located.
	 * @return The conversion data in an associative array or null if there was a HTTP error or if the conversion is not yet done.
	 */
	public function getTranscription($url) {
		$this->response_meta_info = array();
		
		$ch = curl_init($url);
		
		curl_setopt($ch, CURLOPT_USERPWD, $this->username . ':' . $this->password); //This works perfectly for the POST action where I get the converted text URL
		curl_setopt($ch, CURLOPT_HTTPAUTH, CURLAUTH_ANY); //This should use digest if needed
		curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
		curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
		//curl_setopt($ch, CURLOPT_HTTPHEADER, $this->headers);
		//$opts[CURLOPT_HEADERFUNCTION] = array($this, '_readHeader'); //This is done this way because of the object oriented programming method
		//curl_setopt_array($ch, $opts);//This is done this way because of the object oriented programming method
		curl_setopt($ch, CURLOPT_USERAGENT, $this->useragent);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
		curl_setopt($ch, CURLOPT_HEADER, false); // header will be at output
		//register a callback function which will process the headers
		//this assumes your code is into a class method, and uses $this->readHeader as the callback //function
		curl_setopt($ch, CURLOPT_HEADERFUNCTION, array(&$this, 'readRetrievalHeader'));
		
		$result = curl_exec($ch);
		curl_close($ch);
		/*$data = explode("\n", $result);
		 if (strcmp(substr($data[9], 0, 15), "HTTP/1.1 200 OK") == 0) {
			return $result; //This is to break the loop
			}*/
		
		if ($this->response_meta_info['retrieval_status_num'] == 200) {
			
			$xml = simplexml_load_string($result);
			
			$data = array();
			$text = (string)$xml->conversion->text;
			
			$pattern = '/"(.*?)" - spoken through SpinVox/';
			preg_match($pattern, $text, $transcription);
			
			$data['text'] = $transcription[1];
			$data['status'] = $xml->conversion->status;
			
			return $data;
		} else
			return null;
	}
	
	private function readRetrievalHeader($ch, $header) {
		$retrieval_status = $this->extractCustomHeader("HTTP\/1.1 ", '\n', $header);
		if ($retrieval_status) {
			$status = explode(' ', $retrieval_status);
			if ($status[0] == 404)
				$status[1] = 'processing';
			$this->response_meta_info['retrieval_status_num'] = trim($status[0]);
			$this->response_meta_info['retrieval_status'] = trim($status[1]);
		}
		return strlen($header);
	}
	
	/**
	 * Converts the given file into G.711 A-Law mono audio format
	 *
	 * @param $srcFile The video or audio file to be converted.
	 * @param $destFile The destination of the converted file. It must be a wav file.
	 */
	private function convertToAlaw($srcFile, $destFile) {
		// Call our convert using exec()
		if (file_exists($destFile))
			unlink($destFile);
		
		exec("ffmpeg -i " . $srcFile . " -acodec pcm_alaw -ar 8000 -ac 1 " . $destFile, $output);
	}
}

?>
