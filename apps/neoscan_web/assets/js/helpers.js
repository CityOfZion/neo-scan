// Create our number formatter.
export const formatterZero = new Intl.NumberFormat('en-US', {
  style: 'currency',
  currency: 'USD',
  minimumFractionDigits: 0,
  maximumFractionDigits: 0
})

export const formatterTwo = new Intl.NumberFormat('en-US', {
  style: 'currency',
  currency: 'USD',
  minimumFractionDigits: 2
})

export const formatBTC = (num) => num.toFixed(8)
export const formatBTCLarge = (num) => {
  let formatStyle
  if (Number(num) > 1000) {
    formatStyle = new Intl.NumberFormat('en-US', { maximumFractionDigits: 0 })
  } else {
    formatStyle = new Intl.NumberFormat('en-US', { maximumFractionDigits: 2 })
  }
  return formatStyle.format(num)
}

export function getClass (type) {
  if (type === 'ContractTransaction') {
    return 'neo-transaction'
  }
  if (type === 'ClaimTransaction') {
    return 'gas-transaction'
  }
  if (type === 'MinerTransaction') {
    return 'miner-transaction'
  }
  if (type === 'RegisterTransaction') {
    return 'register-transaction'
  }
  if (type === 'IssueTransaction') {
    return 'issue-transaction'
  }
  if (type === 'PublishTransaction') {
    return 'publish-transaction'
  }
  if (type === 'InvocationTransaction') {
    return 'invocation-transaction'
  }
}

export function getName (type) {
  if (type === 'ContractTransaction') {
    return 'Contract'
  }
  if (type === 'ClaimTransaction') {
    return 'GAS Claim'
  }
  if (type === 'MinerTransaction') {
    return 'Miner'
  }
  if (type === 'RegisterTransaction') {
    return 'Register'
  }
  if (type === 'IssueTransaction') {
    return 'Issue'
  }
  if (type === 'PublishTransaction') {
    return 'Publish'
  }
  if (type === 'InvocationTransaction') {
    return 'Invocation'
  }
}

export function getIcon (type) {
  if (type === 'ContractTransaction') {
    return 'fa-cube'
  }
  if (type === 'ClaimTransaction') {
    return 'fa-cubes'
  }
  if (type === 'MinerTransaction') {
    return 'fa-user-circle-o'
  }
  if (type === 'RegisterTransaction') {
    return 'fa-list-alt'
  }
  if (type === 'IssueTransaction') {
    return 'fa-handshake-o'
  }
  if (type === 'PublishTransaction') {
    return 'fa-cube'
  }
  if (type === 'InvocationTransaction') {
    return 'fa-paper-plane'
  }
}
