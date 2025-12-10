SELECT 
                c.collections_id AS collection_id,
                c.code AS collection_code,
                c.name_ch AS collection_name,
                c.release_date,
                c.symbol_url,            -- 改成 symbol_url
                c.collection_type,       -- 保留 collection_type
                COUNT(cards.card_id) AS card_count
            FROM ptcg_collections c
            LEFT JOIN ptcg_pokemon_cards cards ON c.collections_id = cards.collection_id
            GROUP BY c.collections_id, c.code, c.name_ch, c.release_date, c.symbol_url, c.collection_type
            ORDER BY c.collections_id