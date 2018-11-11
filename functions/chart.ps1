Function ChartCreatePie([string]$sTitle, [string]$sUnit)
{
	[void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
	[void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms.DataVisualization")

	# Create our chart object
	$oChart = New-object System.Windows.Forms.DataVisualization.Charting.Chart
	$oChart.Width = 150
	$oChart.Height = 150
	$oChart.Left = 0
	$oChart.Top = 0

	# Create a chartarea to draw on and add this to the chart
	$oChartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea
	$oChart.ChartAreas.Add($oChartArea)
	[void]$oChart.Series.Add("Data")

	# Add a datapoint for each value specified in the arguments (args)
    foreach ($iValue in $args) {
		$oDatapoint = new-object System.Windows.Forms.DataVisualization.Charting.DataPoint(0, $iValue)
	    $oDatapoint.AxisLabel = "$iValue $sUnit"
	    $oChart.Series["Data"].Points.Add($oDatapoint)
	}

	$oChart.Series["Data"].ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Pie
	$oChart.Series["Data"]["PieLabelStyle"] = "Outside"
	$oChart.Series["Data"]["PieLineColor"] = "Black"
	$oChart.Series["Data"]["PieDrawingStyle"] = "Concave"
	($oChart.Series["Data"].Points.FindMaxByValue())["Exploded"] = $true

	# Set the title of the Chart to the current date and time
	$oTitle = new-object System.Windows.Forms.DataVisualization.Charting.Title
    $oTitle.Text = $sTitle
	$oChart.Titles.Add($oTitle)

	# Save the chart to a temp file
    $sFile = [System.IO.Path]::GetTempFileName()
	$oChart.SaveImage($sFile, "png")

    # Convert the file to a string
    $sImage = [Convert]::ToBase64String((Get-Content $sFile -Encoding Byte))

    # Delete the file
    Remove-Item -Path $sFile

    Return $sImage
}
