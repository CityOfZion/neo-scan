const moment = require('moment')

const formatChart = (time) => {
  const width = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth
  let count = width > 600 ? 32 : 8
  let format = '%m-%d-%y'
  if (time === '1d') {
    count = width >   600 ? 24 : 6
    format = '%H:%M'
  }
  if (time === '1w') {
    count = 7
    format = '%m-%d'
  }
  if (time === '3m') {
    count = width > 600 ? 36 : 10
    format = '%m-%d'
  }
  return [count, format]
}

export const createHomeChart = (coin, compareCurrency, time) => {
  fetch(`/price/${coin}/${compareCurrency}/${time}`).then(res => res.json()).then(results => {
    const dates = ['date']
    const prices = [coin.toUpperCase()]
    for (const [unixTimestamp, price] of Object.entries(results)) {
      const formattedDate = moment.unix(unixTimestamp).format('YYYY-MM-DD HH:mm')
      if (dates[dates.length - 1] !== formattedDate) {
        dates.push(formattedDate)
        prices.push(price)
      }
    }

    const [count, format] = formatChart(time)
    const chart = c3.generate({
      bindto: '#market-chart',
      data: {
        x: 'date',
        columns: [
          dates,
          prices
        ],
        xFormat: '%Y-%m-%d %H:%M'
      },
      axis: {
        x: {
          height: 75,
          type: 'timeseries',
          tick: {
            culling: false,
            count,
            rotate: -65,
            format,
            fit: true
          }
        },
        y: {
          tick: {
            format: function (d) {
              if (compareCurrency === 'usd') return '$' + d.toFixed(2)
              if (time === '3m') return d.toFixed(3)
              if (time === '1m') return d.toFixed(4)
              if (time === '1w') return d.toFixed(5)
              return d.toFixed(8)
            }
          }
        }
      },
      grid: {
        y: {
          show: true
        }
      },
      padding: {
        right: 20
      },
      tooltip: {
        contents: function (d) {
          const price = compareCurrency === 'usd' ? d[0] && Number(d[0].value).toFixed(2) : d[0] && Number(d[0].value).toFixed(8)
          const name = d[0] && d[0].name
          const time = d[0] && `${d[0].x}`.slice(0, 24)
          return (`<div class="chart-tooltip"><span class="tooltip-xlabel">Price of ${name} (${compareCurrency})</span><span class="tooltip-xlabel">Time:  ${time}</span><span class="tooltip-${compareCurrency}label">${price}</span></div>`)
        }
      },
      legend: {
        hide: true
      },
      point: {
        show: false
      },
      zoom: {
        enabled: false
      },
      color: {
        pattern: ['#BEEB00']
      }
    })
  })
}

export const createAddressChart = (asset, dates, amounts, count) => {
  const width = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth
  let showCount = width > 600 ? count : Math.max(Math.round(count / 2), 1)
  const chart = c3.generate({
    bindto: '#address-chart',
    data: {
      x: 'date',
      columns: [
        dates,
        amounts
      ],
      xFormat: '%Y-%m-%d %H:%M:%S'
    },
    axis: {
      x: {
        height: 90,
        type: 'timeseries',
        tick: {
          culling: false,
          count: showCount,
          rotate: -65,
          format: '%Y-%m-%d',
          fit: true
        }
      },
      y: {
        tick: {
          format: function (d) {
            return d.toFixed(0)
          }
        }
      }
    },
    legend: {
      hide: true
    },
    grid: {
      y: {
        show: true,
      }
    },
    padding: {
      right: 20
    },
    tooltip: {
      contents: function (d) {
        const name = d[0] && d[0].name
        const value = d[0] && d[0].value
        const time = d[0] && d[0].x
        return (`<div class="chart-tooltip"><span class="tooltip-xlabel">${name}: ${value}</span><span class="tooltip-xlabel">Time: ${time} </span></div>`)
      }
    },
    point: {
      show: false
    },
    zoom: {
      enabled: false,
    },
    color: {
      pattern: ['#BEEB00']
    }
  })
}
