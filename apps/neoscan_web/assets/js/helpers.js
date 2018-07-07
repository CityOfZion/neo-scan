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
  if (type === 'contract_transaction') {
    return 'neo-transaction'
  }
  if (type === 'claim_transaction') {
    return 'gas-transaction'
  }
  if (type === 'miner_transaction') {
    return 'miner-transaction'
  }
  if (type === 'register_transaction') {
    return 'register-transaction'
  }
  if (type === 'issue_transaction') {
    return 'issue-transaction'
  }
  if (type === 'publish_transaction') {
    return 'publish-transaction'
  }
  if (type === 'invocation_transaction') {
    return 'invocation-transaction'
  }
  if (type === 'enrollment_transaction') {
    return 'invocation-transaction'
  }
  if (type === 'state_transaction') {
    return 'invocation-transaction'
  }
}

export function getName (type) {
  if (type === 'contract_transaction') {
    return 'Contract'
  }
  if (type === 'claim_transaction') {
    return 'GAS Claim'
  }
  if (type === 'miner_transaction') {
    return 'Miner'
  }
  if (type === 'register_transaction') {
    return 'Register'
  }
  if (type === 'issue_transaction') {
    return 'Issue'
  }
  if (type === 'publish_transaction') {
    return 'Publish'
  }
  if (type === 'invocation_transaction') {
    return 'Invocation'
  }
  if (type === 'enrollment_transaction') {
    return 'Enrollment'
  }
  if (type === 'state_transaction') {
    return 'Enrollment'
  }
}

export function getIcon (type) {
  if (type === 'contract_transaction') {
    return 'fa-cube'
  }
  if (type === 'claim_transaction') {
    return 'fa-cubes'
  }
  if (type === 'miner_transaction') {
    return 'fa-user-circle-o'
  }
  if (type === 'register_transaction') {
    return 'fa-list-alt'
  }
  if (type === 'issue_transaction') {
    return 'fa-handshake-o'
  }
  if (type === 'publish_transaction') {
    return 'fa-cube'
  }
  if (type === 'invocation_transaction') {
    return 'fa-paper-plane'
  }
  if (type === 'enrollment_transaction') {
    return 'fa-paper-plane'
  }
  if (type === 'state_transaction') {
    return 'fa-paper-plane'
  }
}
