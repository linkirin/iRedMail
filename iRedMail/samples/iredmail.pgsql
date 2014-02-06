-- ---------------------------------------------------------------------
-- This file is part of iRedMail, which is an open source mail server
-- solution for Red Hat(R) Enterprise Linux, CentOS, Debian and Ubuntu.
--
-- iRedMail is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- iRedMail is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with iRedMail.  If not, see <http://www.gnu.org/licenses/>.
-- ---------------------------------------------------------------------

-- Used to store domain admin accounts
CREATE TABLE admin (
    username VARCHAR(255) NOT NULL DEFAULT '',
    password VARCHAR(255) NOT NULL DEFAULT '',
    name VARCHAR(255) NOT NULL DEFAULT '',
    language VARCHAR(5) NOT NULL DEFAULT 'en_US',
    passwordlastchange TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT '1970-01-01 00:00:00',
    created TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT '1970-01-01 00:00:00',
    modified TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT '1970-01-01 00:00:00',
    expired TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT '9999-12-31 00:00:00',
    active INT2 NOT NULL DEFAULT 1,
    PRIMARY KEY (username)
);
CREATE INDEX idx_admin_passwordlastchange ON admin (passwordlastchange);
CREATE INDEX idx_admin_expired ON admin (expired);
CREATE INDEX idx_admin_active ON admin (active);

-- Used to store mail alias accounts
CREATE TABLE alias (
    address VARCHAR(255) NOT NULL DEFAULT '',
    goto TEXT NOT NULL DEFAULT '',
    name VARCHAR(255) NOT NULL DEFAULT '',
    moderators TEXT NOT NULL DEFAULT '',
    accesspolicy VARCHAR(30) NOT NULL DEFAULT '',
    domain VARCHAR(255) NOT NULL DEFAULT '',
    created TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT '1970-01-01 00:00:00',
    modified TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT '1970-01-01 00:00:00',
    expired TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT '9999-12-31 00:00:00',
    active INT2 NOT NULL DEFAULT 1,
    PRIMARY KEY (address)
);
CREATE INDEX idx_alias_domain ON alias (domain);
CREATE INDEX idx_alias_expired ON alias (expired);
CREATE INDEX idx_alias_active ON alias (active);

-- Used to store virtual mail domains
CREATE TABLE domain (
    -- mail domain name. e.g. iredmail.org.
    domain VARCHAR(255) NOT NULL DEFAULT '',
    description TEXT NOT NULL DEFAULT '',
    -- Disclaimer text. Used by Amavisd + AlterMIME.
    disclaimer TEXT NOT NULL DEFAULT '',
    -- Max alias accounts in this domain. e.g. 10.
    aliases INT8 NOT NULL DEFAULT 0,
    -- Max mail accounts in this domain. e.g. 100.
    mailboxes INT8 NOT NULL DEFAULT 0,
    -- Max mailbox quota in this domain. e.g. 1073741824 (1GB).
    maxquota INT8 NOT NULL DEFAULT 0,
    -- Not used. Historical.
    quota INT8 NOT NULL DEFAULT 0,
    -- Per-domain transport. e.g. dovecot, smtp:[192.168.1.1]:25
    transport VARCHAR(255) NOT NULL DEFAULT 'dovecot',
    backupmx INT2 NOT NULL DEFAULT 0,
    -- Default preferred language for newly created mail user.
    defaultlanguage VARCHAR(5) NOT NULL DEFAULT 'en_US',
    -- Default quota size for newly created mail account.
    defaultuserquota INT8 NOT NULL DEFAULT '1024',
    -- List of mail alias addresses assigned to newly created user.
    defaultuseraliases TEXT NOT NULL DEFAULT '',
    -- Disabled domain profiles which can not be viewed and updated by normal
    -- domain admin. Multiple values must be separated by comma.
    disableddomainprofiles VARCHAR(255) NOT NULL DEFAULT '',
    -- Disabled user profiles which can not be viewed and updated by normal
    -- domain admin. Multiple values must be separated by comma.
    disableduserprofiles VARCHAR(255) NOT NULL DEFAULT '',
    -- Default password scheme. e.g. md5, plain.
    defaultpasswordscheme VARCHAR(10) NOT NULL DEFAULT '',
    -- Password length
    minpasswordlength INT8 NOT NULL DEFAULT 0,
    maxpasswordlength INT8 NOT NULL DEFAULT 0,
    created TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT '1970-01-01 00:00:00',
    modified TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT '1970-01-01 00:00:00',
    expired TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT '9999-12-31 00:00:00',
    active INT2 NOT NULL DEFAULT 1,
    PRIMARY KEY (domain)
);
CREATE INDEX idx_domain_backupmx ON domain (backupmx);
CREATE INDEX idx_domain_expired ON domain (expired);
CREATE INDEX idx_domain_active ON domain (active);

-- Used to store alias domains
CREATE TABLE alias_domain (
    alias_domain VARCHAR(255) NOT NULL,
    target_domain VARCHAR(255) NOT NULL,
    created TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT '1970-01-01 00:00:00',
    modified TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT '1970-01-01 00:00:00',
    active INT2 NOT NULL DEFAULT 1,
    PRIMARY KEY (alias_domain)
);
CREATE INDEX idx_alias_domain_target_domain ON alias_domain (target_domain);
CREATE INDEX idx_alias_domain_active ON alias_domain (active);

-- Used to store domain <=> admin relationship
CREATE TABLE domain_admins (
    username VARCHAR(255) NOT NULL DEFAULT '',
    domain VARCHAR(255) NOT NULL DEFAULT '',
    created TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT '1970-01-01 00:00:00',
    modified TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT '1970-01-01 00:00:00',
    expired TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT '9999-12-31 00:00:00',
    active INT2 NOT NULL DEFAULT 1,
    PRIMARY KEY (username,domain)
);
CREATE INDEX idx_domain_admins_username ON domain_admins (username);
CREATE INDEX idx_domain_admins_domain ON domain_admins (domain);
CREATE INDEX idx_domain_admins_active ON domain_admins (active);

-- Used to store virtual mail accounts
CREATE TABLE mailbox (
    username VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL DEFAULT '',
    name VARCHAR(255) NOT NULL DEFAULT '',
    language VARCHAR(5) NOT NULL DEFAULT 'en_US',
    storagebasedirectory VARCHAR(255) NOT NULL DEFAULT '',
    storagenode VARCHAR(255) NOT NULL DEFAULT '',
    maildir VARCHAR(255) NOT NULL DEFAULT '',
    quota INT8 NOT NULL DEFAULT 0, -- Total mail quota size
    domain VARCHAR(255) NOT NULL DEFAULT '',
    transport VARCHAR(255) NOT NULL DEFAULT '',
    department VARCHAR(255) NOT NULL DEFAULT '',
    rank VARCHAR(255) NOT NULL DEFAULT 'normal',
    employeeid VARCHAR(255) DEFAULT '',
    isadmin INT2 NOT NULL DEFAULT 0,
    isglobaladmin INT2 NOT NULL DEFAULT 0,
    enablesmtp INT2 NOT NULL DEFAULT 1,
    enablesmtpsecured INT2 NOT NULL DEFAULT 1,
    enablepop3 INT2 NOT NULL DEFAULT 1,
    enablepop3secured INT2 NOT NULL DEFAULT 1,
    enableimap INT2 NOT NULL DEFAULT 1,
    enableimapsecured INT2 NOT NULL DEFAULT 1,
    enabledeliver INT2 NOT NULL DEFAULT 1,
    enablelda INT2 NOT NULL DEFAULT 1,
    enablemanagesieve INT2 NOT NULL DEFAULT 1,
    enablemanagesievesecured INT2 NOT NULL DEFAULT 1,
    enablesieve INT2 NOT NULL DEFAULT 1,
    enablesievesecured INT2 NOT NULL DEFAULT 1,
    enableinternal INT2 NOT NULL DEFAULT 1,
    enabledoveadm INT2 NOT NULL DEFAULT 1,
    "enablelib-storage" INT2 NOT NULL DEFAULT 1,
    enablelmtp INT2 NOT NULL DEFAULT 1,
    lastlogindate TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT '1970-01-01 00:00:00',
    lastloginipv4 INET NOT NULL DEFAULT '0.0.0.0',
    lastloginprotocol CHAR(255) NOT NULL DEFAULT '',
    disclaimer TEXT NOT NULL DEFAULT '',
    -- Allow emails sent from certain users
    allowedsenders TEXT NOT NULL DEFAULT '',
    -- Reject emails sent from certain users
    rejectedsenders TEXT NOT NULL DEFAULT '',
    -- Allow to sent email to certain users
    allowedrecipients TEXT NOT NULL DEFAULT '',
    -- Reject to sent email to certain users
    rejectedrecipients TEXT NOT NULL DEFAULT '',
    -- Store per-user settings. Used in iRedAdmin-Pro.
    settings TEXT NOT NULL DEFAULT '',
    passwordlastchange TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT '1970-01-01 00:00:00',
    created TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT '1970-01-01 00:00:00',
    modified TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT '1970-01-01 00:00:00',
    expired TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT '9999-12-31 00:00:00',
    active INT2 NOT NULL DEFAULT 1,
    -- Required by PostfixAdmin
    local_part VARCHAR(255) NOT NULL DEFAULT '',
    PRIMARY KEY (username)
);
CREATE INDEX idx_mailbox_domain ON mailbox (domain);
CREATE INDEX idx_mailbox_department ON mailbox (department);
CREATE INDEX idx_mailbox_employeeid ON mailbox (employeeid);
CREATE INDEX idx_mailbox_isadmin ON mailbox (isadmin);
CREATE INDEX idx_mailbox_isglobaladmin ON mailbox (isglobaladmin);
CREATE INDEX idx_mailbox_enablesmtp ON mailbox (enablesmtp);
CREATE INDEX idx_mailbox_enablesmtpsecured ON mailbox (enablesmtpsecured);
CREATE INDEX idx_mailbox_enablepop3 ON mailbox (enablepop3);
CREATE INDEX idx_mailbox_enablepop3secured ON mailbox (enablepop3secured);
CREATE INDEX idx_mailbox_enableimap ON mailbox (enableimap);
CREATE INDEX idx_mailbox_enableimapsecured ON mailbox (enableimapsecured);
CREATE INDEX idx_mailbox_enabledeliver ON mailbox (enabledeliver);
CREATE INDEX idx_mailbox_enablelda ON mailbox (enablelda);
CREATE INDEX idx_mailbox_enablemanagesieve ON mailbox (enablemanagesieve);
CREATE INDEX idx_mailbox_enablemanagesievesecured ON mailbox (enablemanagesievesecured);
CREATE INDEX idx_mailbox_enablesieve ON mailbox (enablesieve);
CREATE INDEX idx_mailbox_enablesievesecured ON mailbox (enablesievesecured);
CREATE INDEX idx_mailbox_enableinternal ON mailbox (enableinternal);
CREATE INDEX idx_mailbox_enabledoveadm ON mailbox (enabledoveadm);
CREATE INDEX idx_mailbox_enablelib_storage ON mailbox ("enablelib-storage");
CREATE INDEX idx_mailbox_passwordlastchange ON mailbox (passwordlastchange);
CREATE INDEX idx_mailbox_expired ON mailbox (expired);
CREATE INDEX idx_mailbox_active ON mailbox (active);

CREATE TABLE sender_bcc_domain (
    domain VARCHAR(255) NOT NULL DEFAULT '',
    bcc_address VARCHAR(255) NOT NULL DEFAULT '',
    created TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT '1970-01-01 00:00:00',
    modified TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT '1970-01-01 00:00:00',
    expired TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT '9999-12-31 00:00:00',
    active INT2 NOT NULL DEFAULT 1,
    PRIMARY KEY (domain)
);
CREATE INDEX idx_sender_bcc_domain_bcc_address ON sender_bcc_domain (bcc_address);
CREATE INDEX idx_sender_bcc_domain_expired ON sender_bcc_domain (expired);
CREATE INDEX idx_sender_bcc_domain_active ON sender_bcc_domain (active);

CREATE TABLE sender_bcc_user (
    username VARCHAR(255) NOT NULL DEFAULT '',
    bcc_address VARCHAR(255) NOT NULL DEFAULT '',
    domain VARCHAR(255) NOT NULL DEFAULT '',
    created TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT '1970-01-01 00:00:00',
    modified TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT '1970-01-01 00:00:00',
    expired TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT '9999-12-31 00:00:00',
    active INT2 NOT NULL DEFAULT 1,
    PRIMARY KEY (username)
);
CREATE INDEX idx_sender_bcc_user_bcc_address ON sender_bcc_user (bcc_address);
CREATE INDEX idx_sender_bcc_user_domain ON sender_bcc_user (domain);
CREATE INDEX idx_sender_bcc_user_expired ON sender_bcc_user (expired);
CREATE INDEX idx_sender_bcc_user_active ON sender_bcc_user (active);

--
-- Table structure for table recipient_bcc_domain
--
CREATE TABLE recipient_bcc_domain (
    domain VARCHAR(255) NOT NULL DEFAULT '',
    bcc_address VARCHAR(255) NOT NULL DEFAULT '',
    created TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT '1970-01-01 00:00:00',
    modified TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT '1970-01-01 00:00:00',
    expired TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT '9999-12-31 00:00:00',
    active INT2 NOT NULL DEFAULT 1,
    PRIMARY KEY (domain)
);
CREATE INDEX idx_recipient_bcc_domain_bcc_address ON recipient_bcc_domain (bcc_address);
CREATE INDEX idx_recipient_bcc_domain_expired ON recipient_bcc_domain (expired);
CREATE INDEX idx_recipient_bcc_domain_active ON recipient_bcc_domain (active);

--
-- Table structure for table recipient_bcc_user
--
CREATE TABLE recipient_bcc_user (
    username VARCHAR(255) NOT NULL DEFAULT '',
    bcc_address VARCHAR(255) NOT NULL DEFAULT '',
    domain VARCHAR(255) NOT NULL DEFAULT '',
    created TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT '1970-01-01 00:00:00',
    modified TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT '1970-01-01 00:00:00',
    expired TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT '9999-12-31 00:00:00',
    active INT2 NOT NULL DEFAULT 1,
    PRIMARY KEY (username)
);
CREATE INDEX idx_recipient_bcc_user_bcc_address ON recipient_bcc_user (bcc_address);
CREATE INDEX idx_recipient_bcc_user_expired ON recipient_bcc_user (expired);
CREATE INDEX idx_recipient_bcc_user_active ON recipient_bcc_user (active);

-- Used to store basic info of deleted mailboxes.
CREATE TABLE deleted_mailboxes (
    id SERIAL PRIMARY KEY,
    timestamp TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    -- Email address of deleted user
    username VARCHAR(255) NOT NULL DEFAULT '',
    -- Domain part of username
    domain VARCHAR(255) NOT NULL DEFAULT '',
    -- Absolute path of user's mailbox
    maildir VARCHAR(255) NOT NULL DEFAULT '',
    -- Deleted by which domain admin
    admin VARCHAR(255) NOT NULL DEFAULT ''
);

CREATE INDEX idx_deleted_mailboxes_timestamp ON deleted_mailboxes (timestamp);
CREATE INDEX idx_deleted_mailboxes_username ON deleted_mailboxes (username);
CREATE INDEX idx_deleted_mailboxes_domain ON deleted_mailboxes (domain);
CREATE INDEX idx_deleted_mailboxes_admin ON deleted_mailboxes (admin);

--
-- IMAP shared folders. User 'from_user' shares folders to user 'to_user'.
-- WARNING: Works only with Dovecot 1.2+.
--
CREATE TABLE share_folder (
    from_user VARCHAR(255) NOT NULL,
    to_user VARCHAR(255) NOT NULL,
    dummy CHAR(1),
    PRIMARY KEY (from_user, to_user)
);
CREATE INDEX idx_share_folder_from_user ON share_folder (from_user);
CREATE INDEX idx_share_folder_to_user ON share_folder (to_user);

CREATE TABLE anyone_shares (
    from_user VARCHAR(255) NOT NULL,
    dummy CHAR(1),
    PRIMARY KEY (from_user)
);

-- used_quota
-- Used to store realtime mailbox quota in Dovecot.
-- WARNING: Works only with Dovecot 1.2+.
--
-- Note: Don't touch this table, it will be updated by Dovecot automatically.
CREATE TABLE used_quota (
    username VARCHAR(255) NOT NULL,
    bytes INT8 NOT NULL DEFAULT 0,
    messages INT8 NOT NULL DEFAULT 0,
    domain VARCHAR(255) NOT NULL DEFAULT '',
    PRIMARY KEY (username)
);
CREATE INDEX idx_used_quota_domain ON used_quota (domain);

-- Trigger required by quota dict
CREATE OR REPLACE FUNCTION merge_quota() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.messages < 0 OR NEW.messages IS NULL THEN
        -- ugly kludge: we came here from this function, really do try to insert
        IF NEW.messages IS NULL THEN
            NEW.messages = 0;
        ELSE
            NEW.messages = -NEW.messages;
        END IF;
        return NEW;
    END IF;

    LOOP
        UPDATE used_quota
        SET bytes = bytes + NEW.bytes, messages = messages + NEW.messages, domain=split_part(NEW.username, '@', 2)
        WHERE username = NEW.username;
        IF found THEN
            RETURN NULL;
        END IF;

        BEGIN
            IF NEW.messages = 0 THEN
                INSERT INTO used_quota (bytes, messages, username, domain)
                VALUES (NEW.bytes, NULL, NEW.username, split_part(NEW.username, '@', 2));
            ELSE
                INSERT INTO used_quota (bytes, messages, username, domain)
                VALUES (NEW.bytes, -NEW.messages, NEW.username, split_part(NEW.username, '@', 2));
            END IF;
            return NULL;
            EXCEPTION WHEN unique_violation THEN
            -- someone just inserted the record, update it
        END;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER mergequota BEFORE INSERT ON used_quota
    FOR EACH ROW EXECUTE PROCEDURE merge_quota();
