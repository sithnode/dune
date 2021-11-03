/*
DROP TABLE IF EXISTS wallet_addresses;
CREATE TEMPORARY TABLE wallet_addresses AS
SELECT DISTINCT LOWER(RIGHT(TRIM(
    UNNEST(STRING_TO_ARRAY('{{1. wallet address}}', ','))
), -2)) AS address;
*/
SELECT
    DISTINCT CONCAT(
        '<a href="https://etherscan.io/tx/0x',
        ENCODE(evt_tx_hash, 'hex'),
        '" target="_blank" rel="noopener noreferrer">',
        '0x', LEFT(ENCODE(evt_tx_hash, 'hex'), 4), '....', RIGHT(ENCODE(evt_tx_hash, 'hex'), 4),
        '</a>'
    ) AS tx,
    
    CAST(evt_block_time AS date) AS date,
    CASE "from"
        WHEN '\xFbdDaDD80fe7bda00B901FbAf73803F2238Ae655'  -- SushiSwap: OHM-DAI 2
        THEN 'Strong Block Service'
        END AS contract,
    'STRONG' AS token,
     CASE
        WHEN "from" IN (
          '\xC0bF97bffA94A50502265C579a3b7086D081664B' --Uniswap v2
            )
        THEN 'Buy'
        WHEN "from" IN (
          '\xfbddadd80fe7bda00b901fbaf73803f2238ae655'  -- Strong Block Service
            )
        THEN 'Redeem Rewards'
        ELSE 'Other'
    END AS transaction_type,
    "from" AS from,

    CAST(   SUM((value * 1e-9 * 1e-9)) OVER (PARTITION BY evt_tx_hash) AS DECIMAL(12,6)) AS eth_amount

FROM erc20."ERC20_evt_Transfer"
  --  JOIN wallet_addresses ON wallet_addresses.address = LOWER(right("to"::text, -2))
WHERE contract_address = '\x990f341946a3fdb507ae7e52d17851b87168017c'  -- STRONG
  AND "to" = '{{1. wallet address}}'
  AND "from" = '\xfbddadd80fe7bda00b901fbaf73803f2238ae655'
  AND evt_block_number >= 12000000  -- Roughly when OlympusDAO launched
GROUP BY evt_tx_hash,
CAST(evt_block_time AS date), "from", transaction_type, contract, value
ORDER BY date DESC
