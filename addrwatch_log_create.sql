CREATE TABLE addrwatch_log
    (
        mac_address VARCHAR(17),
        ip_address VARCHAR(42),
        insert_time unsigned big INT,
        update_time unsigned big INT
    );

CREATE UNIQUE INDEX addrwatch_log_mac_ip_idx
ON addrwatch_log
    (
        mac_address,
        ip_address
    );

