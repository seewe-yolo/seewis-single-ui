-- 目录类型菜单
UPDATE `sys_menu` SET `component` = 'Layout', `icon` = 'carbon:cloud-service-management', `menu_name` = 'route.system' WHERE `menu_id` = 1;
UPDATE `sys_menu` SET `component` = 'Layout', `icon` = 'stash:dashboard', `menu_name` = 'route.monitor' WHERE `menu_id` = 2;
UPDATE `sys_menu` SET `component` = 'Layout', `icon` = 'tabler:tools', `menu_name` = 'route.tool' WHERE `menu_id` = 3;
UPDATE `sys_menu` SET `component` = 'Layout', `icon` = 'tabler:logs', `menu_name` = 'menu.system_log' WHERE `menu_id` = 108;

-- 页面类型
UPDATE `sys_menu` SET `icon` = 'ic:round-manage-accounts', `menu_name` = 'route.system_user' WHERE `menu_id` = 100;
UPDATE `sys_menu` SET `icon` = 'carbon:user-role', `menu_name` = 'route.system_role' WHERE `menu_id` = 101;
UPDATE `sys_menu` SET `icon` = 'material-symbols:route', `menu_name` = 'route.system_menu' WHERE `menu_id` = 102;
UPDATE `sys_menu` SET `icon` = 'mingcute:department-line', `menu_name` = 'route.system_dept' WHERE `menu_id` = 103;
UPDATE `sys_menu` SET `icon` = 'hugeicons:permanent-job', `menu_name` = 'route.system_post' WHERE `menu_id` = 104;
UPDATE `sys_menu` SET `icon` = 'qlementine-icons:dictionary-16', `menu_name` = 'route.system_dict' WHERE `menu_id` = 105;
UPDATE `sys_menu` SET `icon` = 'carbon:parameter', `menu_name` = 'route.system_config' WHERE `menu_id` = 106;
UPDATE `sys_menu` SET `icon` = 'solar:chat-line-outline', `menu_name` = 'route.system_notice' WHERE `menu_id` = 107;
UPDATE `sys_menu` SET `icon` = 'majesticons:status-online-line', `menu_name` = 'route.monitor_online' WHERE `menu_id` = 109;
UPDATE `sys_menu` SET `icon` = 'simple-icons:redis', `menu_name` = 'route.monitor_cache' WHERE `menu_id` = 113;
UPDATE `sys_menu` SET `icon` = 'material-symbols:code-blocks-outline', `menu_name` = 'route.tool_gen' WHERE `menu_id` = 115;
UPDATE `sys_menu` SET `icon` = 'material-symbols:attach-file', `menu_name` = 'route.system_oss' WHERE `menu_id` = 118;
UPDATE `sys_menu` SET `icon` = 'tabler:device-imac-cog', `menu_name` = 'route.system_client' WHERE `menu_id` = 123;
UPDATE `sys_menu` SET `icon` = 'carbon:operations-record', `menu_name` = 'route.monitor_operlog' WHERE `menu_id` = 500;
UPDATE `sys_menu` SET `icon` = 'tabler:login-2', `menu_name` = 'route.monitor_logininfor' WHERE `menu_id` = 501;
UPDATE `sys_menu` SET `path` = 'oss/config', `component` = 'system/oss-config/index', `icon` = 'hugeicons:configuration-01', `menu_name` = 'route.system_oss-config' WHERE `menu_id` = 133;

-- IFrame 类型
UPDATE `sys_menu` SET `component` = 'FrameView', `query_param` = '{"url":"https://ruoyi.xlsea.cn/admin/"}', `is_frame` = 2, `icon` = 'bx:bxl-spring-boot', `menu_name` = 'menu.monitor_admin' WHERE `menu_id` = 117;
UPDATE `sys_menu` SET `component` = 'FrameView', `query_param` = '{"url":"https://preview.snailjob.opensnail.com/"}', `is_frame` = 2, `icon` = 'gridicons:scheduled', `menu_name` = 'menu.monitor_snail-job' WHERE `menu_id` = 120;

-- plus-ui 需要禁用的页面
UPDATE `sys_menu` SET `status` = '1' WHERE `menu_id` IN ( '116', '130', '131', '132' );

-- 仪表盘菜单
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2000, 'route.dashboard', 0, 1, 'dashboard', 'Layout', '', 1, 0, 'M', '0', '0', '', 'mdi:view-dashboard-outline', 103, 1, sysdate(), null, null, '仪表盘目录') ON DUPLICATE KEY UPDATE `menu_name` = VALUES(`menu_name`), `component` = VALUES(`component`), `icon` = VALUES(`icon`), `update_time` = sysdate();
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2001, 'route.dashboard_workbench', 2000, 1, 'workbench', 'dashboard/workbench/index', '', 1, 0, 'C', '0', '0', 'dashboard:workbench', 'mdi:briefcase-outline', 103, 1, sysdate(), null, null, '工作台') ON DUPLICATE KEY UPDATE `menu_name` = VALUES(`menu_name`), `component` = VALUES(`component`), `perms` = VALUES(`perms`), `icon` = VALUES(`icon`), `update_time` = sysdate();
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2002, 'route.dashboard_analysis', 2000, 2, 'analysis', 'dashboard/analysis/index', '', 1, 0, 'C', '0', '0', 'dashboard:analysis', 'mdi:chart-line', 103, 1, sysdate(), null, null, '数据分析') ON DUPLICATE KEY UPDATE `menu_name` = VALUES(`menu_name`), `component` = VALUES(`component`), `perms` = VALUES(`perms`), `icon` = VALUES(`icon`), `update_time` = sysdate();
-- 工作流需要禁用的页面
UPDATE `sys_menu` SET `status` = '1' WHERE `menu_id` IN ( '11616', '11618', '11638', '11700', '11701' );

-- 顶级菜单排序：仪表盘置顶，预留 1-20 给业务模块。
UPDATE `sys_menu` SET `order_num` = 1 WHERE `menu_id` = 2000;
UPDATE `sys_menu` SET `order_num` = 21 WHERE `menu_id` = 1;
UPDATE `sys_menu` SET `order_num` = 22 WHERE `menu_id` = 2;
UPDATE `sys_menu` SET `order_num` = 23 WHERE `menu_id` = 3;
UPDATE `sys_menu` SET `order_num` = 24 WHERE `menu_id` = 11616;
UPDATE `sys_menu` SET `order_num` = 25 WHERE `menu_id` = 11618;
