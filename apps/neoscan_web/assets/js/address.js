const moment = require('moment')

$('document').ready(() => {
  if (window.location.pathname.startsWith('/address/')) {
    const graph_elem = document.getElementById('graph_data')
    const graph_data = JSON.parse(graph_elem.dataset.graphData)
    const count = graph_data.length
    const assetsList = {}
    const dates = ['date']
    graph_data.forEach(({time, assets}) => {
      const date = new Date(time*1000)
      const formattedDate = moment(date).format('YYYY-MM-DD HH:MM:SS')
      if (formattedDate === dates[dates.length-1]) return
      dates.push(formattedDate)

      return assets.forEach((asset) => {
        const assetName = Object.keys(asset)
        if (!assetsList[assetName]) {
          return assetsList[assetName] = [assetName, asset[assetName]]
        } else {
          return assetsList[assetName].push(asset[assetName])
        }
      })
    })

    const transactionsTextElem = document.getElementById('last-x-transactions')
    let transactionText = `Last ${count} Transactions for `

    const assetDropdown = document.getElementById('select-address-chart')
    const assetNames = Object.keys(assetsList)
    assetNames.forEach((name, idx) => {
      const option = document.createElement("option");
      option.text = name;
      option.value = name;
      assetDropdown.add(option);
      if (assetNames[idx+1]) {
        transactionText += `${name}, `
      } else {
        transactionText = transactionText.slice(0,-2)
        transactionText += ` and ${name}`
      }

    })

    transactionsTextElem.innerHTML = transactionText

    if (assetsList['NEO']) {
      createAssetChart('NEO', dates, assetsList['NEO'], count)
    } else if (assetsList['GAS']) {
      createAssetChart('GAS', dates, assetsList['GAS'], count)
    } else if (assetNames.length > 0) {
      createAssetChart(assetNames[0], dates, assetsList[assetNames[0]], count)
    }

    assetDropdown.onchange = function () {
      createAssetChart(this.value, dates, assetsList[this.value], count)
    }
  }
})

const createAssetChart = (asset, dates, amounts, count) => {
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
          count,
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
