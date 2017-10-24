
var neoChart = c3.generate({
  data: {
    x: 'x',
    columns: [
      ['x', '02-11-17', '03-11-17', '04-11-17', '05-11-17', '06-11-17', '07-11-17', '08-11-17', '09-11-17', '10-11-17', '11-11-17', '12-11-17', '13-11-17', '14-11-17', '15-11-17', '16-11-17', '17-11-17', '18-11-17', '19-11-17', '20-11-17', '21-11-17', '22-11-17', '23-11-17', '24-11-17', '25-11-17', '26-11-17', '27-11-17'],
      ['NEO', 69, 72, 75, 84, 66, 90, 87, 86, 63, 68, 72, 75, 81, 90, 92, 99, 82, 93, 77, 71, 69, 82, 88, 94, 102]
    ]
  },
  axis: {
    x: {
      height: 75,
      type: 'timeseries',
      tick: {
        culling: false,
        count: 25,
        rotate: -65,
        format: '%y - %m - %d',
        fit: true
      }
    }
  },
  grid: {
    y: {
      show: true,
      tick: {
        format: d3.format('$,'),
        values: [110, 100, 90, 80, 70, 60]
      }
    }
  },
  tooltip: {
    contents: function (d, defaultTitleFormat, defaultValueFormat, color) {
      return ('<div class="chart-tooltip"><span class="tooltip-xlabel">Xlabel date content here</span><span class="tooltip-neolabel">0.0811</span><span class="tooltip-gaslabel">72.10</span></div>')
    }
  },
  zoom: {
    enabled: true
  },
  point: {
    r: 6,
    focus: {
      expand: {
        r: 8
      }
    }
  },
  color: {
    pattern: ['#BEEB00']
  },
  onrendered: function () {
    var $$ = this
    var circles = $$.getCircles()
    for (var i = 0; i < circles.length; i++) {
      for (var j = 0; j < circles[i].length; j++) {
        $$.getCircles(j).style('fill', '#313164')
            .style('fill', $$.color)
            .style('stroke-width', 2)
      }
    }
  }
})

var gasChart = c3.generate({
  data: {
    x: 'x',
    columns: [
      ['x', '02-11-17', '03-11-17', '04-11-17', '05-11-17', '06-11-17', '07-11-17', '08-11-17', '09-11-17', '10-11-17', '11-11-17', '12-11-17', '13-11-17', '14-11-17', '15-11-17', '16-11-17', '17-11-17', '18-11-17', '19-11-17', '20-11-17', '21-11-17', '22-11-17', '23-11-17', '24-11-17', '25-11-17', '26-11-17', '27-11-17'],
      ['GAS', 69, 72, 75, 84, 66, 90, 87, 86, 63, 68, 72, 75, 81, 90, 92, 99, 82, 93, 77, 71, 69, 82, 88, 94, 102]
    ]
  },
  axis: {
    x: {
      height: 75,
      type: 'timeseries',
      tick: {
        culling: false,
        count: 25,
        rotate: -65,
        format: '%y - %m - %d',
        fit: true
      }
    }
  },
  grid: {
    y: {
      show: true,
      tick: {
        format: d3.format('$,'),
        values: [110, 100, 90, 80, 70, 60]
      }
    }
  },
  tooltip: {
    contents: function (d, defaultTitleFormat, defaultValueFormat, color) {
      return ('<div class="chart-tooltip"><span class="tooltip-xlabel">Xlabel date content here</span><span class="tooltip-neolabel">0.0811</span><span class="tooltip-gaslabel">72.10</span></div>')
    }
  },
  zoom: {
    enabled: true
  },
  point: {
    r: 6,
    focus: {
      expand: {
        r: 8
      }
    }
  },
  color: {
    pattern: ['#BEEB00']
  },
  onrendered: function () {
    var $$ = this
    var circles = $$.getCircles()
    for (var i = 0; i < circles.length; i++) {
      for (var j = 0; j < circles[i].length; j++) {
        $$.getCircles(j).style('fill', '#313164')
            .style('fill', $$.color)
            .style('stroke-width', 2)
      }
    }
  }
})
