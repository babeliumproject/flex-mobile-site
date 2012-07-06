<?php

/**
 * Babelium Project open source collaborative second language oral practice - http://www.babeliumproject.com
 * 
 * Copyright (c) 2011 GHyM and by respective authors (see below).
 * 
 * This file is part of Babelium Project.
 *
 * Babelium Project is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Babelium Project is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

if(!defined('SERVICE_PATH'))
	define('SERVICE_PATH', '/services/');

if(!defined('WEBROOT_PATH'))
	define('WEBROOT_PATH', '/var/www/babelium');	
	
require_once WEBROOT_PATH . SERVICE_PATH . 'utils/Config.php';

/**
 * Helper class to perform media transcoding tasks.
 * Uses ffmpeg as an underlying technology.
 *
 * @author Inko Perurena
 */
class VideoProcessor{

	private $uploadsPath;
	private $imagePath;
	private $red5Path;

	private $frameWidth4_3;
	private $frameWidth16_9;
	private $frameHeight;

	private $mediaContainer;
	private $encodingPresets = array();

	private $conn;

	public function VideoProcessor(){
		$settings = new Config();

		$this->uploadsPath = $settings->filePath;
		$this->imagePath = $settings->imagePath;
		$this->red5Path = $settings->red5Path;

		$this->frameWidth4_3 = $settings->frameWidth4_3;
		$this->frameWidth16_9 = $settings->frameWidth16_9;
		$this->frameHeight = $settings->frameHeight;

		$this->encodingPresets[] = "ffmpeg -y -i '%s' -s %dx%d -g 25 -qmin 3 -b 512k -acodec libmp3lame -ar 22050 -ac 2 -f flv '%s' 2>&1";
		$this->encodingPresets[] = "ffmpeg -y -i '%s' -s %dx%d -g 25 -qmin 3 -acodec libmp3lame -ar 22050 -ac 2 -f flv '%s' 2>&1";

	}

	/**
	 * Determines if the given parameter is a media container and if so retrieves information about it's
	 * different streams and duration.
	 *
	 * @param string $filePath
	 * @throws Exception
	 */
	public function retrieveMediaInfo($filePath){
		$cleanPath = escapeshellcmd($filePath);
		if(is_file($cleanPath) && filesize($cleanPath)>0){
			$output = (exec("ffmpeg -i '$cleanPath' 2>&1",$cmd));
			$strCmd = implode($cmd);
			$this->mediaContainer = new stdclass();
			if($this->isMediaFile($strCmd)){
				$this->mediaContainer->hash = md5_file($cleanPath);
				$this->retrieveAudioInfo($strCmd);
				$this->retrieveVideoInfo($strCmd);
				$this->retrieveDuration($strCmd);
				if($this->mediaContainer->hasVideo == true)
					$this->retrieveVideoAspectRatio();
				return $this->mediaContainer;
			} else {
				throw new Exception("Unknown media format");
			}
		} else {
			throw new Exception("Not a file");
		}
	}

	/**
	 * Checks if the provided file has an acceptable mimeType.
	 *
	 * @param string $filePath
	 */
	private function checkMimeType($filePath){
		$cleanPath = escapeshellcmd($filePath);
		if(is_file($cleanPath) && filesize($cleanPath)>0){
			
			//Not always returns accurate info on the mime type
			//$finfo = finfo_open(FILEINFO_MIME_TYPE);
    		//$file_mime = finfo_file($finfo, $file_path);
			//finfo_close($finfo);
			
			$output = (exec("file -bi '$cleanPath' 2>&1",$cmd));

			$implodedOutput = implode($cmd);
			$fileMimeInfo = explode($implodedOutput, ";");
			$fileMimeType = $fileMimeInfo[0];

			$validMime = false;

			/*
			foreach($this->mimeTypes as $mimeType ){
				if($mimeType == $fileMimeType){
					//The mime of this file is among the accepted mimes list
					$validMime = true;
					break;
				}
			}
			*/
			
			if(strpos($implodedOutput,'video') !== false){
				$validMime = true;
			}
			
			return $validMime ? $fileMimeType : "Not valid mime type";
		} else {
			throw new Exception("Not a file");
		}
	}

	/**
	 * Deletes the provided file from the filesystem. This operation cannot be undone. Use with caution.
	 *
	 * @param string $filePath
	 */
	private function deleteVideoFile($filePath) {
		$cleanPath = escapeshellcmd($filePath);
		if(is_file($cleanPath) && filesize($cleanPath)>0){
			$success = @unlink ( $cleanPath );
			return $success;
		} else {
			return false;
		}
	}

	/**
	 * Checks if the file provided to ffmpeg is a recognizable media file.
	 *
	 * $ffmpegOutput should be an string that contains all the output of "ffmpeg -i fileName"
	 *
	 * @param string $ffmpegOutput
	 */
	private function isMediaFile($ffmpegOutput){
		$error1 = strpos($ffmpegOutput, 'Unknown format');
		$error2 = strpos($ffmpegOutput, 'Error while parsing header');
		$error3 = strpos($ffmpegOutput, 'Invalid data found when processing input');
		if ($error1 === false && $error2 === false && $error3 === false) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * Checks if the provided media file contains any audio streams and if so, stores all the info of that audio.
	 * Not all audio codecs provide info about the bitrate so the last group of the regExp is optional.
	 *
	 * $ffmpegOutput should be an string that contains all the output of "ffmpeg -i fileName"
	 *
	 * @param string $ffmpegOutput
	 */
	private function retrieveAudioInfo($ffmpegOutput){
		if(preg_match('/Audio: (([\w\s\/\[\]:]+), ([\w\s\/\[\]:]+), ([\w\s\/\[\]:\.]+), ([\w\s\/\[\]:]+)(, \w+\s\w+\/s)?)/s', $ffmpegOutput, $audioinfo)){
			$this->mediaContainer->hasAudio = true;
			$this->mediaContainer->audioCodec = trim($audioinfo[2]);
			$this->mediaContainer->audioRate = trim($audioinfo[3]);
			$this->mediaContainer->audioChannels = trim($audioinfo[4]);
			$this->mediaContainer->audioBits = trim($audioinfo[5]);
			if(count($audioinfo) == 7)
			$this->mediaContainer->audioBitrate = trim(str_replace(",","",$audioinfo[6]));
		} else {
			$this->mediaContainer->hasAudio = false;
		}
	}

	/**
	 * Checks if the provided media file contains any video streams and if so, stores all the info of that video.
	 * Not all video codecs provide info about the bitrate so the fourth group of the regExp is optional.
	 *
	 * $ffmpegOutput should be an string that contains all the output of "ffmpeg -i fileName"
	 *
	 * @param string $ffmpegOutput
	 */
	private function retrieveVideoInfo($ffmpegOutput){
		if(preg_match('/Video: (([\w\s\/\[\]:]+), ([\w\s\/\[\]:]+), ([\w\s\/\[\]:]+), ([\w\s\/\[\]:]+, )?([\w\s\/\[\]:]+, )?([\w\.]+\stbr), ([\w\.]+\stbn), ([\w\.]+\stbc))/s', $ffmpegOutput, $result)){
			$this->mediaContainer->hasVideo = true;
			$this->mediaContainer->videoCodec = trim($result[2]);
			$this->mediaContainer->videoColorspace = trim($result[3]);
			$this->mediaContainer->videoResolution = trim($result[4]);
			//After the previous parameters there's a chance the codec provides [0-2] fields that give info about the video's bitrate and fps
			$paramCount = count($result);
			if($paramCount == 8){
				$this->mediaContainer->videoTbr = trim($result[5]);
				$this->mediaContainer->videoTbn = trim($result[6]);
				$this->mediaContainer->videoTbc = trim($result[7]);
			}
			if($paramCount == 9){
				$this->mediaContainer->videoFpsBitrate = str_replace(",","",trim($result[5]));
				$this->mediaContainer->videoTbr = trim($result[6]);
				$this->mediaContainer->videoTbn = trim($result[7]);
				$this->mediaContainer->videoTbc = trim($result[8]);
			}
			if($paramCount == 10){
				$this->mediaContainer->videoBitrate= str_replace(",","",trim($result[5]));
				$this->mediaContainer->videoFps = str_replace(",","",trim($result[6]));
				$this->mediaContainer->videoTbr = trim($result[7]);
				$this->mediaContainer->videoTbn = trim($result[8]);
				$this->mediaContainer->videoTbc = trim($result[9]);
			}

			if($this->mediaContainer->videoResolution){
				//Some codecs provide info about the Pixel Aspect Ratio (PAR) and Display Aspect Ratio (DAR). We don't need that info for now.
				$resolutionWithAspectRatioInfo = explode(" ",$this->mediaContainer->videoResolution);
				//Even if there's no AR info the explode should leave the results in the first index of the array
				$resolution = explode("x",$resolutionWithAspectRatioInfo[0]);
				$this->mediaContainer->videoWidth = $resolution[0];
				$this->mediaContainer->videoHeight = $resolution[1];
			}
		} else {
			$this->mediaContainer->hasVideo = false;
		}
	}

	/**
	 * Calculates the duration (in seconds) of the provided media file.
	 *
	 * @param string $ffmpegOutput
	 */
	private function retrieveDuration($ffmpegOutput){
		$totalTime = 0;
		if (preg_match('/Duration: ((\d+):(\d+):(\d+))/s', $ffmpegOutput, $time)) {
			$totalTime = ($time[2] * 3600) + ($time[3] * 60) + $time[4];
		}
		$this->mediaContainer->duration = $totalTime;
	}

	/**
	 * Determines the video file's aspect ratio and suggests an standard aspect ratio
	 * for transcoding.
	 */
	private function retrieveVideoAspectRatio(){
		if(!$this->mediaContainer->hasVideo || !$this->mediaContainer->videoHeight || !$this->mediaContainer->videoWidth)
			throw new Exception("Operation not allowed on non-video files");
			
		if($this->mediaContainer->videoWidth > $this->mediaContainer->videoHeight){
			$originalRatio = $this->mediaContainer->videoWidth / $this->mediaContainer->videoHeight;
			$this->mediaContainer->originalAspectRatio = $originalRatio;
				
			$deviation16_9 = abs(((16/9)-$originalRatio));
			$deviation4_3 = abs(((4/3)-$originalRatio));
			$this->mediaContainer->suggestedTranscodingAspectRatio = ($deviation4_3 < $deviation16_9) ? 43 : 169;
		} else{
			$this->mediaContainer->suggestedTranscodingAspectRatio = 43;
		}
		return $this->mediaContainer->suggestedTranscodingAspectRatio;
	}


	/**
	 * Takes a thumbnail image of the provided video and leaves it at the defined destination. Checks if the provided paths
	 * are readable/writable and if needed retrieves the info of the provided video file.
	 *
	 * @param string $filePath
	 * @param string $outputImagePath
	 * @throws Exception
	 */
	public function takeRandomSnapshot($filePath, $outputImagePath, $snapshotWidth = 120, $snapshotHeight = 90){
		$cleanPath = escapeshellcmd($filePath);
		$cleanImagePath = escapeshellcmd($outputImagePath);

		if(!is_readable($cleanPath))
			throw new Exception("You don't have enough permissions to read from the input");
		if(!is_writable(dirname($cleanImagePath)))
			throw new Exception("You don't have enough permissions to write to the output");
		if($this->mediaContainer->hash != md5_file($cleanPath)){
			try {
				//This file hasn't been scanned yet
				$this->retrieveMediaInfo($cleanPath);
			} catch (Exception $e) {
				throw new Exception($e->getMessage());
			}
		}

		//Default thumbnail time
		$second = 1;
		//Random time between 0 and videoDuration
		$second = rand(1, ($this->mediaContainer->duration - 1));

		$resultsnap = (exec("ffmpeg -y -i '$cleanPath' -ss $second -vframes 1 -r 1 -s ". $snapshotWidth . "x" . $snapshotHeight ." '$cleanImagePath' 2>&1",$cmd));
		return $resultsnap;
	}

	/**
	 * Transcodes the provided video file into an FLV container video with stereo MP3 audio. Checks if the provided paths
	 * are readable/writable and if needed retrieves the info of the provided video file.
	 *
	 * The preset parameter defines the encoding preset index the function will be using. Normally presets are arranged by
	 * produced quality level in top-down way. So preset[0] is the best available quality and preset[n] is the worst available.
	 *
	 * @param string $inputFilepath
	 * @param string $outputFilepath
	 * @param int $preset
	 * @throws Exception
	 */
	public function transcodeToFlv($inputFilepath, $outputFilepath, $preset = 1){
		$cleanInputPath = escapeshellcmd($inputFilepath);
		$cleanOutputPath = escapeshellcmd($outputFilepath);
			
		if(!is_readable($cleanInputPath))
			throw new Exception("You don't have enough permissions to read from the input");
		if(!is_writable(dirname($cleanOutputPath)))
			throw new Exception("You don't have enough permissions to write to the output");

		if(!$this->mediaContainer || !$this->mediaContainer->hash || $this->mediaContainer->hash != md5_file($cleanInputPath)){
			try {
				//This file hasn't been scanned yet
				$this->retrieveMediaInfo($cleanInputPath);
			} catch (Exception $e) {
				throw new Exception($e->getMessage());
			}
		}

		if ($this->mediaContainer->suggestedTranscodingAspectRatio == 43){
			$width = $this->frameWidth4_3;
			$height = $this->frameHeight;
		} else {
			$width = $this->frameWidth16_9;
			$height = $this->frameHeight;
		}

		if($this->mediaContainer->hasAudio){
			//5.1 AAC audio can't be downmixed to stereo audio using ffmpeg
			if($this->mediaContainer->audioCodec == 'aac' && $this->mediaContainer->audioChannels == '5.1'){
				/*
			 	 * A workaround for this issue could be to transcode the audio to an 5.1 AC3 file first using
			 	 * MKV as a container (because it can contain most formats without complaining) and then
			 	 * transcoding this MKV using our regular transcoding preset. For now, we will cancel the
			 	 * transcoding process and raise an exception.
			 	 */
				throw new Exception("Non-transcodable audio. Transcode aborted.");
			}
		}

		if($preset >=0 && $preset < count($this->encodingPresets)){
			$sysCall = sprintf($this->encodingPresets[$preset],$cleanInputPath, $width, $height, $cleanOutputPath);
			$result = (exec($sysCall,$output));
			return $result;
		} else {
			throw new Exception("Non-valid preset was chosen. Transcode aborted.");
		}
	}


	/**
	 * Returns a provided character long random alphanumeric string
	 *
	 * @author Peter Mugane Kionga-Kamau
	 * http://www.pmkmedia.com
	 *
	 * @param int $length
	 * @param boolean $useupper
	 * @param boolean $usenumbers
	 */
	public function str_makerand ($length, $useupper, $usenumbers)
	{
		$key= '';
		$charset = "abcdefghijklmnopqrstuvwxyz";
		if ($useupper)
		$charset .= "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		if ($usenumbers)
		$charset .= "0123456789";
		for ($i=0; $i<$length; $i++)
		$key .= $charset[(mt_rand(0,(strlen($charset)-1)))];
		return $key;
	}

}

?>