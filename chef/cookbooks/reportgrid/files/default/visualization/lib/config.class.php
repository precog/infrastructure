<?php

class Config
{
	private static $VALID_FORMATS = array('png', 'pdf', 'jpg', 'html');
	private static $VALID_ELEMENTS = array('div', 'span');
	var $tokenId;
	var $css;
	var $id;
	var $className;
	var $format;
	var $xml;
	var $params;
	var $backgroundColor;
	var $element;

	public function __construct($tokenId, $css, $id, $className, $format, $xml, $params, $backgroundColor, $element)
	{
		$this->tokenId = $tokenId;
		$this->css = $css;
		$this->id = $id;
		$this->className = $className;
		$this->format = $format;
		$this->xml = $xml;
		$this->params = $params;
		$this->backgroundColor = $backgroundColor;
		$this->element = $element;

		$this->validate();
	}

	public function hash()
	{
		$format = $this->format;
		$this->format = null;
		$hash = hash('md5', var_export($this, true));
		$this->format = $format;
		return $hash;
	}

	private function validate()
	{
		if(!$this->tokenId)
			throw new Exception("Token cannot be empty or null");
		if(!$this->css)
			$this->css = array();
		else if(is_string($this->css))
			$this->css = explode(",",$this->css);
		else if(!is_array($this->css))
			throw new Exception("CSS must be a string or an array of strings");
		
		if(null == $this->id)
			$this->id = "chart";

		if($this->className)
		{
			// sanitize classname
			$parts = preg_split('/\s+/', $this->className);
			$rg = array_search('rg', $parts);
			if($rg !== false)
				unset($parts[$rg]);
			$this->className = implode(' ', $parts);
		}

		if(null == $this->format)
			$this->format = "png";
		else 
			$this->format = strtolower($this->format);
		
		if(!in_array($this->format, Config::$VALID_FORMATS))
			throw new Exception("Invalid output format '{$this->format}'");
		
		if(($this->xml && $this->params) || (!$this->xml && !$this->params))
			throw new Exception("You must pass either the 'xml' or 'params' argument");

		// protect against injections or malicious scripts
		if($this->xml)
		{
			if(get_magic_quotes_gpc())
				$this->xml = stripslashes($this->xml);
//			$dom = new DomDocument();
//			$dom->loadXML($this->xml);
//			$this->xml = $dom->saveXML();
		}

		if($this->params)
		{
			if(get_magic_quotes_gpc())
				$this->params = stripslashes($this->params);
//			$this->params = json_encode(json_decode($this->params, true), true);
		}

		if(!$this->element)
			$this->element = 'div';
		else
			$this->element = strtolower($this->element);
		
		if(!in_array($this->element, Config::$VALID_ELEMENTS))
			throw new Exception("invalid element container '{$this->element}'");
	}

	public static function fromQueryString($params)
	{
		return new Config(@$params['tokenId'], @$params['css'], @$params['id'], @$params['className'], @$params['format'], @$params['xml'], @$params['params'], @$params['backgroundcolor'], @$params['element']);
	}
}