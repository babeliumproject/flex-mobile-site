<?php

/**
 * Compare two texts using the cosime metric method
 * 
 * @author Blizarazu, inko (Java->PHP Port)
 */
class CosineMeasure {

	private $wordsCommon;
	private $wordsFirst; //Array of words of the first text
	private $wordsSecond; //Array of words of the second text

	/**
	 * Constructor function
	 * @param array $wordsFirst
	 * 		An array with the words of the first text
	 * @param array $wordsSecond
	 * 		An array with the words of the second text
	 */
	public function CosineMeasure($wordsFirst, $wordsSecond) {
		$this->wordsCommon = array();
		$this->wordsFirst = $wordsFirst;
		$this->wordsSecond = $wordsSecond;
	}

	/**
	 * Compares the given word arrays with the cosine metric method. 
	 * 
	 * @return float $result
	 * 		The percentage of similarity betweeen the words of the texts
	 */
	public function compareTexts() {
		$this->buildWordsCommon($this->processWords($this->wordsFirst), $this->processWords($this->wordsSecond));
		foreach ($this->wordsFirst as $w1){
			$this->addAppearence(1, $w1);
		}
		foreach ($this->wordsSecond as $w2){
			$this->addAppearence(2, $w2);
		}
		$appearencesFirst = $this->getAppearences(1); //array of int
		$appearencesSecond = $this->getAppearences(2); //array of int

		$num = 0;
		for ($i = 0; $i < count($this->wordsCommon); $i++){
			$num = $num + ($appearencesFirst[$i] * $appearencesSecond[$i]);
		}

		$den1 = 0;
		foreach ($appearencesFirst as $i1){
			$den1 = $den1 + pow($i1, 2);
		}
		$den1 = sqrt($den1);

		$den2 = 0;
		foreach ($appearencesSecond as $i2){
			$den2 = $den2 + pow($i2, 2);
		}
		$den2 = sqrt($den2);

		$den = $den1 * $den2;
		$quotient = $num / $den;

		$result = round($quotient, 2, PHP_ROUND_HALF_UP); //float value
		return $result;
	}

	/**
	 * Returns the times that each word appear on each text
	 * 
	 * @param int $i
	 * 		The target text number
	 * @return array $appearences
	 * 		How many times each word appears in the specified text
	 */
	private function getAppearences($i) {
		$appearences = array();
		for ($j = 0; $j < count($this->wordsCommon); $j++){
			if($i == 1)
			$appearences[$j] = $this->wordsCommon[$j]->appearencesOnFirstText;
			if($i == 2)
			$appearences[$j] = $this->wordsCommon[$j]->appearencesOnSecondText;
		}
		return $appearences;
	}

	/**
	 * Add an appeareance for the provided word in the word array if the word is found in that array
	 * 
	 * @param int $i
	 * 		The target text number
	 * @param string $word
	 */
	private function addAppearence($i, $word) {

		$temp = new stdClass();
		$temp->word = $word;
		$temp->appearencesOnFirstText = 0;
		$temp->appearencesOnSecondText = 0;

		$pos = array_search($temp,$this->wordsCommon);
		if ($pos >= 0){
			if($i == 1)
			$this->wordsCommon[$pos]->appearencesOnFirstText++;
			if($i == 2)
			$this->wordsCommon[$pos]->appearencesOnSecondText++;
		}
	}

	/**
	 * Adds the different words to a common array
	 * 
	 * @param array $wordAppearences1
	 * 		The words and their appearences on the first text
	 * @param array $wordAppearences2
	 * 		The words and their appearences on the second text
	 */
	private function buildWordsCommon($wordAppearences1, $wordAppearences2) {
		foreach ($wordAppearences1 as $l1) {
			if (!in_array($l1,$this->wordsCommon))
			array_push($this->wordsCommon,$l1);
		}
		foreach ($wordAppearences2 as $l2) {
			if (!in_array($l2,$this->wordsCommon))
			array_push($this->wordsCommon,$l2);
		}
	}

	/**
	 * Convert word strings to a class that stores also the numbere of times the word appears on each text
	 * 
	 * @param array $words
	 * 		Unprocessed string array that contains the words of a text
	 * @return array $wordCounts
	 * 		Object array that contains the words of a text with appearence indicators
	 */
	private function processWords($words){
		$wordCounts = array();
		foreach($words as $word){
			$temp = new stdClass();
			$temp->word = $word;
			$temp->appearencesOnFirstText = 0;
			$temp->appearencesOnSecondText = 0;
			array_push($wordCounts,$temp);
		}
		return $wordCounts;
	}
}

?>
