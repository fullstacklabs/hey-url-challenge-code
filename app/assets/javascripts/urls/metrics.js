window.onload = function(){
  google.charts.load('current', {packages: ['corechart']});
  google.charts.setOnLoadCallback(drawCharts);

  function drawTotalClicksChart() {
    var element = document.querySelector("#total-clicks-chart");
    console.log(element);
    if(element != null){
      var data = google.visualization.arrayToDataTable([
        ['day', 'clicks'],
      ].concat(JSON.parse(element.dataset.totalClicks)));

      var options = {
        title: 'total clicks',
        haxis: {
          title: 'day of month'
        },
        vaxis: {
          title: 'clicks'
        }
      };

      var chart = new google.visualization.AreaChart(
        document.getElementById('total-clicks-chart')
      );
      chart.draw(data, options);
    }
  }

  function drawBrowsersChart() {
    var element = document.querySelector("#browsers-chart");
    if(element != null){
      var data = google.visualization.arrayToDataTable([
        ['browser', 'clicks'],
      ].concat(JSON.parse(element.dataset.browsers)));

      var options = {
        title: 'Browsers'
      };

      var chart = new google.visualization.PieChart(
        document.getElementById('browsers-chart')
      );
      chart.draw(data, options);
    }
  }

  function drawPlatformsChart() {
    var element = document.querySelector("#platforms-chart");

    if(element != null){
      var data = google.visualization.arrayToDataTable([
        ['platform', 'clicks'],
      ].concat(JSON.parse(element.dataset.platforms)));

      var options = {
        title: 'Platform'
      };

      var chart = new google.visualization.PieChart(
        document.getElementById('platforms-chart')
      );
      chart.draw(data, options);
    }
  }

  function drawCharts() {
    drawTotalClicksChart();
    drawBrowsersChart();
    drawPlatformsChart();
  }
}