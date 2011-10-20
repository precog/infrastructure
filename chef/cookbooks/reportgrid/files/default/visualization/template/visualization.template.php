<html>
<head>
<title>ReportGrid Renderer</title>
<script src="http://api.reportgrid.com/js/reportgrid-core.js?tokenId=<?=$config->tokenId?>" type="text/javascript"></script>
<script src="http://api.reportgrid.com/js/reportgrid-viz.js" type="text/javascript"></script>
<?php
for($i=0;$i<count($config->css);$i++)
{
    echo "<link href=\"{$config->css[$i]}\" rel=\"stylesheet\" type=\"text/css\" />\n";
}
?>
</head>
<body>
<<?=$config->element?><?=$config->id?' id="'.$config->id.'"':''?><?=$config->className?' class="'.$config->className.'"':''?>></<?=$config->element?>>
<script type="text/javascript"><![CDATA[

var params = <?=$config->params?>;
params.options = params.options || {};
params.options.ready = function() { RG_READY = true; };
params.options.track = { enabled : false };
params.options.animation = { animated : false };
params.options.visualization = params.options.visualization || "linechart";

ReportGrid.viz("<?=$config->id?'#'.$config->id:'.'.str_replace(' ', '.', $config->className)?>", params);

window.setTimeout(function() {
    RG_READY = true;
}, 15000);
]]></script>
</body>
</html>