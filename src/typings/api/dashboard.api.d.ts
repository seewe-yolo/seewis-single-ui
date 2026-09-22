/**
 * Namespace Api
 *
 * Dashboard and workflow api types
 */
declare namespace Api {
  namespace Dashboard {
    type Trend = {
      date: string;
      userCount: number;
      noticeCount: number;
      operationCount: number;
    };

    type Distribution = {
      code: string;
      count: number;
    };

    type Summary = {
      userCount: number;
      deptCount: number;
      noticeCount: number;
      operationCount: number;
      trends: Trend[];
      userStatus: Distribution[];
    };
  }

  namespace Workflow {
    type Task = {
      id: CommonType.IdType;
      flowName: string;
      businessTitle: string;
      nodeName: string;
      flowStatus: string;
      createByName: string;
      createTime: string;
    };

    type TaskSearchParams = CommonType.RecordNullable<
      Pick<Task, 'nodeName' | 'flowName' | 'flowStatus'> & Api.Common.CommonSearchParams
    >;

    type TaskList = Api.Common.PaginatingQueryRecord<Task>;
  }
}
