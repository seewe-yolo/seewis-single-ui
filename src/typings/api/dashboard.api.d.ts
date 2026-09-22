/**
 * Namespace Api
 *
 * Dashboard api types
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
}
