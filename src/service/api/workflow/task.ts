import { request } from '@/service/request';

/** 获取当前用户待办任务 */
export function fetchGetTaskWaitList(params?: Api.Workflow.TaskSearchParams) {
  return request<Api.Workflow.TaskList>({
    url: '/workflow/task/pageByTaskWait',
    method: 'get',
    params
  });
}
