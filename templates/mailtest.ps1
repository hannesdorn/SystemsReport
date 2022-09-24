# Assemble the HTML Header and CSS for our report
$sHtmlHeader1 = @"
<!doctype html>
<html lang="de">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Systems Monitor</title>

    <style type="text/css">
    <!--
 "@

 $sHtmlStyles = @"
        body {
            font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
        }
"@

$sHtmlHeader2 =
@"
    -->
    </style>
</head>

<body>
<div class="mailtest">
"@

$sHtmlFooter =
@"
</div>
</body>

</html>
"@
