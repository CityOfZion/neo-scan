import HomeSocket from './home_socket'
import Inferno from 'inferno'
import List from 'inferno-virtual-list'
import { createHomeChart, createAddressChart } from './create_charts'
import { getClass, getName, getIcon, formatterZero, formatterTwo, formatBTC, formatBTCLarge } from './helpers'

const moment = require('moment')

const blocksContainer = document.getElementById('blocks-wrapper')
const transactionsContainer = document.getElementById('transactions-wrapper')

const blockRow = row => (
  <div class='full-width-bar block-number'>
    <div class='information-wrapper'>
      <p class='fa fa-signal medium-detail-text'></p>
      <a href={'/block/' + row.hash} alt='View block' title='View block' class='large-blue-link col-4-width'>{row.index.toLocaleString()}</a>
      <div class='secondary-info-wrapper'>
        <p class='medium-detail-text col-3-width'><span class='tablet-detail-text'>Size: </span>{row.size.toLocaleString()} bytes</p>
        <p class='medium-detail-text col-3-width'><span class='tablet-detail-text'>Transactions: </span>{row.tx_count.toLocaleString()}</p>
        <p class='medium-detail-text col-2-width'><span class='tablet-detail-text'>Created: </span>{ moment.unix(row.time).format('DD-MM-YYYY') + ' | ' + moment.unix(row.time).format('HH:mm:ss')}</p>
      </div>
    </div>
  </div>
)

const transactionRow = row => (
  <div class={'full-width-bar ' + getClass(row.type)}>
    <div class='information-wrapper'>
      <p class='medium-detail-text col-2-width'><span class={'fa ' + getIcon(row.type)}></span>{getName(row.type)}</p>
      <div class='secondary-info-wrapper'>
        <p class='medium-detail-text col-2-width'><span class='tablet-detail-text'>Txid: </span><a href={'/transaction/' + row.txid} alt='View transaction' title='View transaction' class='large-blue-link col-6-width'>{row.txid}</a></p>
        <p class='medium-detail-text col-2-width remove-550px'><span class='tablet-detail-text'>Created: </span>{ moment.unix(row.time).format('DD-MM-YYYY') + ' | ' + moment.unix(row.time).format('HH:mm:ss')}</p>
      </div>
    </div>
  </div>
)

window.onload = function () {
  // homepage javascript
  if (window.location.pathname === '/') {
    let displayCoin = 'neo'
    let displayChart = 'usd'
    let displayTime = '1m'

    let payload = {
      blocks: [],
      transactions: [],
      stats: {},
      price: {}
    }
    let home = new HomeSocket(payload)

    setInterval(function () {
      Inferno.render((
        <List class='blocks-list' sync={false} data={home.payload.blocks} rowHeight={15} rowRender={blockRow} />
      ), blocksContainer)
      Inferno.render((
        <List class='transactions-list' sync={false} data={home.payload.transactions} rowHeight={15} rowRender={transactionRow} />
      ), transactionsContainer)
      if (home.payload.price && home.payload.price.neo && home.payload.price.gas) {
        const coinPayload = displayCoin === 'neo' ? home.payload.price.neo[displayChart] : home.payload.price.gas[displayChart]
        document.getElementById('total-tx').innerHTML = home.payload.stats.total_transactions.length > 1 && home.payload.stats.total_transactions[1].toLocaleString()
        document.getElementById('total-blocks').innerHTML = (home.payload.stats.total_blocks - 1).toLocaleString()
        document.getElementById('total-addresses').innerHTML = home.payload.stats.total_addresses.toLocaleString()
        document.getElementById('mkt-graph-coin-price').innerHTML = displayChart === 'usd' ? formatterTwo.format(coinPayload.PRICE) : `฿ ${formatBTC(coinPayload.PRICE)}`
        document.getElementById('mkt-cap-us').innerHTML = displayChart === 'usd' ? formatterZero.format(coinPayload.MKTCAP) : `฿ ${formatBTCLarge(coinPayload.MKTCAP)}`
        document.getElementById('24hvol').innerHTML = displayChart === 'usd' ? formatterZero.format(coinPayload.TOTALVOLUME24HTO) : `฿ ${formatBTCLarge(coinPayload.TOTALVOLUME24HTO)}`

        document.getElementById('24hchange').innerHTML = coinPayload.CHANGEPCT24HOUR.toFixed(2) +'%'

        if (coinPayload.TOTALVOLUME24HTO.toFixed(0) > 0) {
          document.getElementById('24hvol').setAttribute('class', 'large-stat-number remove-margin-bottom')
        } else {
          document.getElementById('24hvol').setAttribute('class', 'large-stat-number remove-margin-bottom')
        }

        if (coinPayload.CHANGEPCT24HOUR.toFixed(2) > 0) {
          document.getElementById('24hchange').setAttribute('class', 'large-stat-number large-number-positive remove-margin-bottom')
        } else {
          document.getElementById('24hchange').setAttribute('class', 'large-stat-number large-number-negative remove-margin-bottom')
        }
      }
    }, 500)
    home.connect()

    createHomeChart(displayCoin, displayChart, displayTime)

    const gasChart = document.getElementById('gas-chart')
    const neoChart = document.getElementById('neo-chart')
    const btcChart = document.getElementById('btc-chart')
    const usdChart = document.getElementById('usd-chart')
    const zoomInChart = document.getElementById('zoom-in-chart')
    const zoomOutChart = document.getElementById('zoom-out-chart')

    const setRadioButton = (type) => {
      if (type === 'neo') {
        neoChart.classList.add('radio-active')
        gasChart.classList.remove('radio-active')
      } else if (type === 'gas') {
        gasChart.classList.add('radio-active')
        neoChart.classList.remove('radio-active')
      } else if (type === 'usd') {
        usdChart.classList.add('radio-active')
        btcChart.classList.remove('radio-active')
      } else if (type === 'btc') {
        btcChart.classList.add('radio-active')
        usdChart.classList.remove('radio-active')
      }
    }

    const coinClickHandler = (coin) => {
      displayCoin = coin
      document.getElementById('mkt-graph-coin').innerHTML = coin.toUpperCase()
      setRadioButton(coin)
      return createHomeChart(coin, displayChart, displayTime)
    }

    const compareClickHandler = (compare) => {
      displayChart = compare
      setRadioButton(compare)
      return createHomeChart(displayCoin, compare, displayTime)
    }

    const zoomHandler = (zoom) => {
      if (displayTime === '1d') {
        if (zoom === 'in') return
        displayTime = '1w'
      } else if (displayTime === '1w') {
        displayTime = zoom === 'out' ? '1m' : '1d'
      } else if (displayTime === '1m') {
        displayTime = zoom === 'out' ? '3m' : '1w'
      } else if (displayTime === '3m') {
        if (zoom === 'out') return
        displayTime = '1m'
      }
      return createHomeChart(displayCoin, displayChart, displayTime)
    }

    gasChart.onclick = () => coinClickHandler('gas')
    neoChart.onclick = () => coinClickHandler('neo')
    btcChart.onclick = () => compareClickHandler('btc')
    usdChart.onclick = () => compareClickHandler('usd')
    zoomInChart.onclick = () => zoomHandler('in')
    zoomOutChart.onclick = () => zoomHandler('out')
  }

  // address page javascript
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
    let transactionText = `Last 30 days transactions`

    const assetDropdown = document.getElementById('select-address-chart')
    const assetNames = Object.keys(assetsList)
    assetNames.forEach((name, idx) => {
      const option = document.createElement("option");
      option.text = name;
      option.value = name;
      if(name == 'NEO'){
        option.selected = true;
      }
      assetDropdown.add(option);
    })

    transactionsTextElem.innerHTML = transactionText

    createAddressChart('NEO', dates, assetsList['NEO'], count)

    assetDropdown.onchange = function () {
      createAddressChart(this.value, dates, assetsList[this.value], count)
    }

    const address_hash = document.getElementById('address_hash').innerHTML
    fetch(`/api/main_net/v1/get_unclaimed/${address_hash}`).then(res => res.json()).then(results => {
      document.getElementsByClassName('loading-gas')[0].innerHTML = ''
      document.getElementsByClassName('unclaimed-gas')[0].innerHTML = `${results.unclaimed.toLocaleString('en-GB', {maximumFractionDigits: 8})} Unclaimed Gas`
    })
  }

  // transactions page
  if (window.location.pathname.startsWith('/transactions/')) {
    $('#transactions-dropdown').on('click', function () {
      $('.transactions-dropdown-options').toggle()
    })
    $('.transactions-dropdown-options li').each(function () {
      $(this).on('click', function () {
        const type = $(this).attr('value');
        if (type === 'any') {
          window.location.href = '/transactions/1'
        } else {
          window.location.href = `/transactions/type/${type}/1`
        }
      })
    })
  }
}

const acc = document.getElementsByClassName('btn-accordion')
let i

for (i = 0; i < acc.length; i++) {
  acc[i].onclick = function () {
    this.classList.toggle('active')
    let panel = this.nextElementSibling

    if (panel.style.maxHeight) {
      panel.style.maxHeight = null
    } else {
      panel.style.maxHeight = panel.scrollHeight + 'px'
    }
  }
}

$('document').ready(function () {
  const $hamburger = $('.hamburger')
  $hamburger.on('click', function (e) {
    $hamburger.toggleClass('is-active')

    if ($hamburger.hasClass('is-active')) {
      $('.nav-wrapper').addClass('active-wrapper')
    } else {
      $('.nav-wrapper').removeClass('active-wrapper')
    }

    if (window.matchMedia('(max-width: 660px)').matches && ($hamburger.hasClass('is-active'))) {
      $('.searchbar').addClass('mobile-active')
      $('.search-btn').addClass('mobile-active')
    } else {
      $('.searchbar').removeClass('mobile-active')
      $('.search-btn').removeClass('mobile-active')
    }
  })
  $('.tooltip-btn').on('click', function () {
    if ($(this).text().trim() === 'Tooltips On') {
      window.location.href = '?tooltips=off'
    } else if ($(this).text().trim() === 'Tooltips Off') {
      window.location.href = '?tooltips=on'
    }
  })
  $('#language-dropdown').on('click', function () {
    $('.language-dropdown-options').toggle()
  })
  $('.language-dropdown-options li').each(function () {
    $(this).on('click', function () {
      const lang = $(this).attr('value');
      window.location.href = `?locale=${lang}`
    })
  })

})
