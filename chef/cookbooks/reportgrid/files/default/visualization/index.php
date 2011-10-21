<?

define("PHANTOMJS", "DISPLAY=:0 /usr/local/bin/phantomjs");

require_once('lib/config.class.php');

if(isset($_GET['file']))
{
	$file = $_GET['file'];
	$path = path($file);
	$format = array_pop(explode('.', $file));
	
	switch($format)
	{
		case "png":
			header("Content-Type: image/png");
			break;
		case "jpg":
			header("Content-Type: image/jpeg");
			break;
		case "pdf":
			header("Content-Type: application/pdf");
			break;
	}
	
	header("Content-Description: File Transfer");
//	header('Content-Type: application/octet-stream');
	header("Content-Disposition: attachment; filename=visualization.$format");
	header("Content-Transfer-Encoding: binary");
	header("Content-Length: " . filesize($path));
	
	
	
	readfile($path);
	exit;
}

try
{
	$config = Config::fromQueryString($_REQUEST);
//	dump($config);
/*
	if('html' == $config->format)
	{
		printTemplate($config);
	} else {
		*/
		$hash = $config->hash();
		$output = path($hash,'xhtml');
		if(!file_exists($output))
			captureTemplate($config, $output);

		$imagepath = path($hash, $config->format);

		if(!file_exists($imagepath))
			$out = renderVisualization($output, $imagepath);
		
		echo "$hash.{$config->format}";
		/*
		if(isset($_GET['callback']))
		{
			$url = url($hash, $config->format);
			echo $_GET['callback']."('$url');";
		} else {
			switch($config->format)
			{
				case "png":
					header("Content-Type: image/png");
					break;
				case "jpg":
					header("Content-Type: image/jpeg");
					break;
				case "pdf":
					header("Content-Type: application/pdf");
					break;
			}
			header("Content-Disposition", "attachment; filename=reportgridvisualization.{$config->format}");
			header("Content-Length: " . filesize($imagepath));
			readfile($path);
		}
		*/
		exit;
//	}
} catch(Exception $e) {
	echo $e->getMessage();
	exit;
}

function renderVisualization($input, $output)
{
	return phantom("renderer.js", $input, $output);
}

function phantom($script, $input, $output)
{
	$dir = __DIR__;
	$bin = escapeshellcmd(PHANTOMJS);
	$options = " --config=$dir/phantom/config.json";
	$args = "$dir/$input  $dir/$output";
	$script = "$dir/phantom/$script";
	$cmd = "$bin$options $script $args";

	shell_exec('export DYLD_LIBRARY_PATH="";');
	return shell_exec($cmd);
}

function baseUrl()
{
	$base = reset(explode("?", $_SERVER['REQUEST_URI']));
	if(substr($base, -4) == '.php')
		$base = dirname($base);
	$base = trim($base, "/");
	if($base)
		$base .= "/";
	return "http://{$_SERVER['SERVER_NAME']}/$base";
}

function url($name, $ext = null)
{
	return baseUrl() . 'cache/'.$name.(null == $ext ? '' : '.'.$ext);
}

function path($name, $ext = null)
{
	return 'cache/'.$name.(null == $ext ? '' : '.'.$ext);
}

function captureTemplate($config, $output)
{
	ob_start();
	printTemplate($config);
	$content = ob_get_contents();
	ob_end_clean();
	file_put_contents($output, $content);
}

function printTemplate($config)
{
	if($config->params)
		require_once('template/visualization.template.php');
	else
		require_once('template/xml.template.php');
}

function dump($v)
{
	echo "<pre>";
	var_dump($v);
	echo "</pre>";
}