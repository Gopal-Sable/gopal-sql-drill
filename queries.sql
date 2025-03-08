-- organization table
CREATE TABLE IF NOT EXISTS organization (
    id INT PRIMARY KEY AUTO_INCREMENT,
    org_name VARCHAR(255) NOT NULL
);

-- channels table
CREATE TABLE IF NOT EXISTS channels (
    id INT PRIMARY KEY AUTO_INCREMENT,
    channel_name VARCHAR(255) NOT NULL,
    organization_id INT,
    FOREIGN KEY (organization_id) REFERENCES organization(id)
);

-- users table
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_name VARCHAR(255) NOT NULL
);

-- user_channels table (mapping users to channels)
CREATE TABLE IF NOT EXISTS user_channels (
    channel_id INT NOT NULL,
    user_id INT NOT NULL,
    FOREIGN KEY (channel_id) REFERENCES channels(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- messages table
CREATE TABLE IF NOT EXISTS messages (
    id INT PRIMARY KEY AUTO_INCREMENT,
    message TEXT NOT NULL,
    post_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    user_id INT,
    channel_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (channel_id) REFERENCES channels(id) 
);

-- organization data
INSERT INTO organization(id, org_name) VALUES (1, "Lambda School");

-- user data
INSERT INTO users(id, user_name) 
VALUES 
    (1, "Alice"),
    (2, "Bob"),
    (3, "Chris");

-- channel data
INSERT INTO channels(id, channel_name, organization_id) 
VALUES 
    (1, "general", 1),
    (2, "random", 1);

-- user-channel mappings
INSERT INTO user_channels(channel_id, user_id)
VALUES 
    (1, 1), 
    (2, 1),  
    (1, 2), 
    (2, 3);  

INSERT INTO messages(message, user_id, channel_id) 
VALUES 
    ("msg from Alice #general", 1, 1),  
    ("msg from Bob #general", 2, 1),  
    ("msg from Chris #random", 3, 2),       
    ("msg from Bob #general", 2, 1),
    ("msg from Chris #random", 3, 2),
    ("msg from Alice #random", 1, 2),
    ("msg from Alice #general", 1, 1),
    ("msg from Bob #general", 2, 1),
    ("msg from Chris #random", 3, 2),
    ("msg from Bob #general", 2, 1);

-- List all organization names.
SELECT org_name AS name FROM organization;

-- List all channel names.
SELECT channel_name AS name FROM channels;

-- List all channels in a specific organization by organization name.
SELECT 
    channel_name, 
    org_name 
FROM channels c
JOIN organization o 
    ON o.id = c.organization_id
WHERE o.org_name = "Lambda School";

-- List all messages in a specific channel by channel name #general in order of post_time, descending.
SELECT 
    message, 
    post_time 
FROM messages m 
JOIN channels c 
    ON c.id = m.channel_id
WHERE c.channel_name = 'general'
ORDER BY post_time DESC;

-- List all channels to which user Alice belongs.
SELECT channel_name 
FROM channels c 
JOIN user_channels uc 
    ON uc.channel_id = c.id
JOIN 
    users u ON uc.user_id = u.id
WHERE u.user_name = "Alice";

-- List all users that belong to channel #general.
SELECT user_name 
FROM users u
JOIN user_channels uc 
    ON uc.user_id = u.id
JOIN channels c 
    ON uc.channel_id = c.id
WHERE c.channel_name = "general";

-- List all messages in all channels by user Alice.
SELECT message, channel_name 
FROM messages m 
JOIN channels c 
    ON m.channel_id = c.id
JOIN users u 
    ON u.id = m.user_id
WHERE u.user_name = "Alice";

-- List all messages in #random by user Bob.
SELECT message, user_name, channel_name 
FROM messages m 
JOIN channels c 
    ON m.channel_id = c.id
JOIN users u 
    ON u.id = m.user_id
WHERE u.user_name = "Bob" AND c.channel_name = "random";

-- List the count of messages across all channels per user. (Hint: COUNT, GROUP BY.)
SELECT 
    user_name, 
    COUNT(message) AS message_count 
FROM messages m 
JOIN users u 
    ON u.id = m.user_id
GROUP BY user_name;

-- [Stretch!] List the count of messages per user per channel.
SELECT 
    user_name, 
    channel_name, 
    COUNT(message) AS message_count 
FROM messages m 
JOIN channels c 
    ON m.channel_id = c.id
JOIN users u 
    ON u.id = m.user_id
GROUP BY 
    user_name,
    channel_name;


-- What SQL keywords or concept would you use if you wanted to automatically delete all messages by a user if that user were deleted from the user table?
--  ON DELETE CASCADE;
