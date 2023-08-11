-- add project root to lua package path so requires work when the cwd is not
-- the project root
package.path = PANDOC_STATE.user_data_dir .. "/../?.lua;" .. package.path
