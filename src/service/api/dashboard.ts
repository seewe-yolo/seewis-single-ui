import { request } from '@/service/request';

/** 获取工作台摘要 */
export function fetchGetDashboardSummary() {
  return request<Api.Dashboard.Summary>({
    url: '/dashboard/summary',
    method: 'get'
  });
}

/** 获取数据分析摘要 */
export function fetchGetDashboardAnalysis(days: number = 7) {
  return request<Api.Dashboard.Summary>({
    url: '/dashboard/analysis',
    method: 'get',
    params: { days }
  });
}
