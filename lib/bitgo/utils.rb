module Bitgo
  class Utils

    def self.transaction_outputs(wallet_id:, tx:)
      output_list = []

      tx['amount'] = 0;


      tx['entries'].each do |entry|
        if entry['account'] === wallet_id
          tx['net_value'] = entry['value']
          break;
        end
      end

      tx['outputs'].each do |output|
        if tx['net_value'].nil? || ((tx['net_value'] < 0 && output['chain'] === 1) || (tx['net_value'] > 0 && !output['isMine']))
          next;
        end

        output['net_value'] = output['isMine'] ? output['value'] : -output['value'];
        tx['amount'] += output['net_value']

        record = {
          account: '',
          address: output['account'],
          category:  (output['isMine'] ? 'receive' : 'send'),
          amount: output['net_value'] / 100_000_000.0,
          vout: output['vout'],
          confirmations: tx['confirmations'],
          blockhash: tx['blockhash'],
          txid: tx['id'],
          instant: tx['instant'],
          instantId: tx['instantId'],
          height: tx['height'],
          satoshis: output['value']
        }

        record['fee'] = -tx['fee'] / 100_000_000.0 if tx['net_value'] < 0
        output_list.push(record);
      end

      output_list
    end

  end
end
