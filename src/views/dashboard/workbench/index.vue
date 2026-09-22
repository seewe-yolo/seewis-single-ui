<script setup lang="ts">
import { computed, onMounted, ref } from 'vue';
import { fetchGetDashboardSummary } from '@/service/api/dashboard';
import { fetchGetNoticeList } from '@/service/api/system/notice';
import { fetchGetTaskWaitList } from '@/service/api/workflow/task';
import { useAuthStore } from '@/store/modules/auth';
import { useRouterPush } from '@/hooks/common/router';
import { $t } from '@/locales';

defineOptions({
  name: 'DashboardWorkbench'
});

const authStore = useAuthStore();
const { routerPushByKey } = useRouterPush();

const loading = ref(false);
const loadError = ref(false);
const taskError = ref(false);
const summary = ref<Api.Dashboard.Summary | null>(null);
const taskRows = ref<Api.Workflow.Task[]>([]);
const taskTotal = ref(0);
const noticeRows = ref<Api.System.Notice[]>([]);

const taskSearchParams: Api.Workflow.TaskSearchParams = {
  pageNum: 1,
  pageSize: 5,
  nodeName: null,
  flowName: null,
  flowStatus: null,
  params: {}
};

const noticeSearchParams: Api.System.NoticeSearchParams = {
  pageNum: 1,
  pageSize: 5,
  noticeTitle: null,
  noticeType: null,
  params: {}
};

const summaryCards = computed(() => [
  {
    key: 'todo',
    label: $t('page.dashboard.todoCount'),
    value: taskTotal.value,
    icon: 'material-symbols:task-alt'
  },
  {
    key: 'user',
    label: $t('page.dashboard.userCount'),
    value: summary.value?.userCount ?? 0,
    icon: 'material-symbols:group-outline'
  },
  {
    key: 'dept',
    label: $t('page.dashboard.deptCount'),
    value: summary.value?.deptCount ?? 0,
    icon: 'mingcute:department-line'
  },
  {
    key: 'notice',
    label: $t('page.dashboard.noticeCount'),
    value: summary.value?.noticeCount ?? 0,
    icon: 'solar:chat-line-outline'
  }
]);

const userName = computed(() => authStore.userInfo.user?.nickName || authStore.userInfo.user?.userName || '');

const today = new Intl.DateTimeFormat(undefined, {
  year: 'numeric',
  month: 'long',
  day: 'numeric'
}).format(new Date());

async function getData() {
  loading.value = true;
  loadError.value = false;
  taskError.value = false;

  const [summaryResult, taskResult, noticeResult] = await Promise.all([
    fetchGetDashboardSummary(),
    fetchGetTaskWaitList(taskSearchParams),
    fetchGetNoticeList(noticeSearchParams)
  ]);

  if (summaryResult.error) {
    loadError.value = true;
  } else {
    summary.value = summaryResult.data;
  }

  if (taskResult.error) {
    taskError.value = true;
    taskRows.value = [];
    taskTotal.value = 0;
  } else {
    taskRows.value = taskResult.data.rows;
    taskTotal.value = taskResult.data.total;
  }

  if (noticeResult.error) {
    loadError.value = true;
  } else {
    noticeRows.value = noticeResult.data.rows;
  }

  loading.value = false;
}

function getNoticeTypeLabel(type: Api.System.NoticeType) {
  return type === '1' ? $t('page.dashboard.notice') : $t('page.dashboard.announcement');
}

function goToTodo() {
  routerPushByKey('dashboard_analysis');
}

function goToNotice() {
  routerPushByKey('system_notice');
}

onMounted(getData);
</script>

<template>
  <div class="min-h-500px flex-col-stretch gap-16px overflow-hidden lt-sm:overflow-auto">
    <NCard :bordered="false" size="small" class="card-wrapper">
      <div class="flex flex-wrap items-center justify-between gap-16px">
        <div>
          <h2 class="text-20px font-semibold">{{ $t('page.dashboard.greeting', { userName }) }}</h2>
          <p class="mt-8px text-#999">{{ today }}</p>
        </div>
        <NSpace>
          <NButton secondary @click="goToTodo">{{ $t('page.dashboard.viewAnalysis') }}</NButton>
          <NButton secondary @click="goToNotice">{{ $t('page.dashboard.viewNotice') }}</NButton>
          <NButton type="primary" :loading="loading" @click="getData">{{ $t('page.dashboard.refresh') }}</NButton>
        </NSpace>
      </div>
    </NCard>

    <NGrid cols="1 s:2 m:4" responsive="screen" :x-gap="16" :y-gap="16">
      <NGi v-for="item in summaryCards" :key="item.key">
        <NCard :bordered="false" size="small" class="card-wrapper h-full">
          <div class="flex items-center justify-between">
            <div>
              <div class="text-#999">{{ item.label }}</div>
              <NStatistic class="mt-8px" :value="item.value" />
            </div>
            <SvgIcon :icon="item.icon" class="text-32px text-primary" />
          </div>
        </NCard>
      </NGi>
    </NGrid>

    <NAlert v-if="loadError" type="warning" :title="$t('page.dashboard.partialLoad')" closable>
      {{ $t('page.dashboard.partialLoadDesc') }}
    </NAlert>

    <NGrid cols="1 s:1 m:2" responsive="screen" :x-gap="16" :y-gap="16">
      <NGi>
        <NCard :title="$t('page.dashboard.todoTitle')" :bordered="false" size="small" class="card-wrapper h-full">
          <template #header-extra>
            <NButton text type="primary" @click="goToTodo">{{ $t('page.dashboard.viewAll') }}</NButton>
          </template>
          <NSpin :show="loading">
            <NAlert v-if="taskError" type="info" :title="$t('page.dashboard.todoUnavailable')">
              {{ $t('page.dashboard.todoUnavailableDesc') }}
            </NAlert>
            <NEmpty v-else-if="!taskRows.length" :description="$t('page.dashboard.emptyTodo')" />
            <NList v-else hoverable>
              <NListItem v-for="task in taskRows" :key="task.id">
                <NThing :title="task.businessTitle || task.flowName" :description="task.createTime">
                  <template #description>
                    <NSpace :size="8">
                      <span>{{ task.createTime }}</span>
                      <NTag size="small" type="info">{{ task.nodeName }}</NTag>
                    </NSpace>
                  </template>
                </NThing>
              </NListItem>
            </NList>
          </NSpin>
        </NCard>
      </NGi>

      <NGi>
        <NCard :title="$t('page.dashboard.noticeTitle')" :bordered="false" size="small" class="card-wrapper h-full">
          <template #header-extra>
            <NButton text type="primary" @click="goToNotice">{{ $t('page.dashboard.viewAll') }}</NButton>
          </template>
          <NSpin :show="loading">
            <NEmpty v-if="!noticeRows.length" :description="$t('page.dashboard.emptyNotice')" />
            <NList v-else hoverable>
              <NListItem v-for="notice in noticeRows" :key="notice.noticeId">
                <NThing :title="notice.noticeTitle" :description="notice.createTime">
                  <template #description>
                    <NSpace :size="8">
                      <span>{{ notice.createTime }}</span>
                      <NTag size="small" type="warning">{{ getNoticeTypeLabel(notice.noticeType) }}</NTag>
                    </NSpace>
                  </template>
                </NThing>
              </NListItem>
            </NList>
          </NSpin>
        </NCard>
      </NGi>
    </NGrid>
  </div>
</template>

<style scoped></style>
