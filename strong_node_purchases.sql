-- Strong Node Purchases


SELECT 
    ROW_NUMBER () OVER (
           ORDER BY a.evt_block_time
        ) AS row,
    CONCAT(
        '<a href="https://etherscan.io/tx/0x',
        ENCODE(a.evt_tx_hash, 'hex'),
        '" target="_blank" rel="noopener noreferrer">',
        '0x', LEFT(ENCODE(a.evt_tx_hash, 'hex'), 4), '....', RIGHT(ENCODE(a.evt_tx_hash, 'hex'), 4),
        '</a>'
    ) AS tx,
    a.evt_block_time,
    date_trunc('hour',a.evt_block_time) "hour",
    CAST(median_price AS decimal(16,2))::money AS price,
    a.value * 1e-9 * 1e-9 AS STRONG,
    CAST(median_price * value * 1e-9 * 1e-9 AS decimal(16,2))::money AS total
   
    FROM erc20."ERC20_evt_Transfer" a
    --JOIN wallet_addresses
   --   ON wallet_addresses.address = LOWER(right("to"::text, -2))
        
        INNER JOIN dex.view_token_prices px ON px.hour = date_trunc('hour',evt_block_time) AND px.contract_address = '\x990f341946a3fdb507ae7e52d17851b87168017c' -- STRONG
        
    WHERE a.contract_address = '\x990f341946a3fdb507ae7e52d17851b87168017c'  -- Strong
    AND a."to" = '\xfbddadd80fe7bda00b901fbaf73803f2238ae655' -- Strong Service
    AND a."from" = '{{1. wallet address}}' -- Wallet Address
    AND a.evt_block_number >= 12000000  -- Roughly when OlympusDAO launched

    ORDER BY a.evt_block_time DESC
      
