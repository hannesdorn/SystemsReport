# Assemble the HTML Header and CSS for our Report
$sHtmlHeader1 = @"
<!doctype html>
<html lang="de">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Systems Report</title>

    <style type="text/css">
    <!--
 "@

 $sHtmlStyles = @"
        body {
            font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
        }

        table {
            border-collapse: collapse;
            border: none;
            font: 10pt Verdana, Geneva, Arial, Helvetica, sans-serif;
            color: black;
            margin-bottom: 10px;
            width: 100%;
        }

        th {
            font-size: 12px;
            font-weight: bold;
            padding-left: 0px;
            padding-right: 20px;
            text-align: left;
            vertical-align: top;
        }

        td {
            font-size: 12px;
            padding-left: 0px;
            padding-right: 20px;
            text-align: left;
            vertical-align: top;
            word-break: break-all;
        }

        h2 {
            clear: both;
            font-size: 130%;
        }

        h3 {
            clear: both;
            font-size: 115%;
            margin-top: 30px;
        }

        p {
            font-size: 12px;
        }

        img {
            float: left;
        }

        .list td:nth-child(1) {
            font-weight: bold;
            border-right: 1px grey solid;
            text-align: right;
        }

        .list td:nth-child(2) {
            padding-left: 7px;
        }

        tr:nth-child(even) td:nth-child(even) {
            background: #CCCCCC;
        }
        tr:nth-child(odd) td:nth-child(odd) {
            background: #F2F2F2;
        }
        tr:nth-child(even) td:nth-child(odd) {
            background: #DDDDDD;
        }
        tr:nth-child(odd) td:nth-child(even) {
            background: #E5E5E5;
        }

        .report {
            max-width: 900px;
        }
"@

$sHtmlHeader2 =
@"
    -->
    </style>
</head>

<body>
<div class="report">
"@

$sHtmlFooter =
@"
</div>
</body>

</html>
"@
