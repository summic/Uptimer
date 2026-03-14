-- Beforeve fork defaults.
-- Keep append-only. Only replace untouched upstream defaults.

UPDATE settings
SET value = 'Beforeve Status'
WHERE key = 'site_title' AND value = 'Uptimer';

UPDATE settings
SET value = 'Real-time status and incident updates for Beforeve services.'
WHERE key = 'site_description' AND value = '';
