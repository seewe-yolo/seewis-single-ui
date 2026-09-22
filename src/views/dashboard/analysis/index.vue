<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue';
import type { DataTableColumns } from 'naive-ui';
import { fetchGetDashboardAnalysis } from '@/service/api/dashboard';
import { useEcharts } from '@/hooks/common/echarts';
import { $t } from '@/locales';

defineOptions({
  name: 'DashboardAnalysis'
});

const days = ref(7);
const loading = ref(false);
const loadError = ref(false);
const summary = ref<Api.Dashboard.Summary | null>(null);

const daysOptions = computed(() => [
  { label: $t('page.dashboard.last7Days'), value: 7 },
  { label: $t('page.dashboard.last30Days'), value: 30 }
]);

const summaryCards = computed(() => [
  { key: 'user', label: $t('page.dashboard.userCount'), value: summary.value?.userCount ?? 0 },
  { key: 'dept', label: $t('page.dashboard.deptCount'), value: summary.value?.deptCount ?? 0 },
  { key: 'notice', label: $t('page.dashboard.noticeCount'), value: summary.value?.noticeCount ?? 0 },
  { key: 'operation', label: $t('page.dashboard.operationCount'), value: summary.value?.operationCount ?? 0 }
]);

const trendColumns: DataTableColumns<Api.Dashboard.Trend> = [
  { title: $t('page.dashboard.date'), key: 'date' },
  { title: $t('page.dashboard.userCount'), key: 'userCount' },
  { title: $t('page.dashboard.noticeCount'), key: 'noticeCount' },
  { title: $t('page.dashboard.operationCount'), key: 'operationCount' }
];

const { domRef: trendDomRef, updateOptions: updateTrendOptions } = useEcharts(() => ({
  tooltip: { trigger: 'axis' },
  legend: {
    data: [$t('page.dashboard.userCount'), $t('page.dashboard.noticeCount'), $t('page.dashboard.operationCount')]
  },
  grid: { left: '3%', right: '4%', bottom: '3%', top: '18%' },
  xAxis: { type: 'category', data: [] as string[] },
  yAxis: { type: 'value' },
  series: [
    { name: $t('page.dashboard.userCount'), type: 'line', smooth: true, data: [] as number[] },
    { name: $t('page.dashboard.noticeCount'), type: 'line', smooth: true, data: [] as number[] },
    { name: $t('page.dashboard.operationCount'), type: 'line', smooth: true, data: [] as number[] }
  ]
}));

const { domRef: statusDomRef, updateOptions: updateStatusOptions } = useEcharts(() => ({
  tooltip: { trigger: 'item' },
  legend: { bottom: '1%', left: 'center' },
  series: [
    {
      name: $t('page.dashboard.userStatus'),
      type: 'pie',
      radius: ['45%', '72%'],
      data: [] as { name: string; value: number }[]
    }
  ]
}));

async function getData() {
  loading.value = true;
  loadError.value = false;
  const { data, error } = await fetchGetDashboardAnalysis(days.value);
  if (error) {
    loadError.value = true;
    loading.value = false;
    return;
  }

  summary.value = data;
  await updateTrendOptions(opts => {
    opts.xAxis.data = data.trends.map(item => item.date);
    opts.series[0].data = data.trends.map(item => item.userCount);
    opts.series[1].data = data.trends.map(item => item.noticeCount);
    opts.series[2].data = data.trends.map(item => item.operationCount);
    return opts;
  });
  await updateStatusOptions(opts => {
    opts.series[0].data = data.userStatus.map(item => ({
      name: getStatusLabel(item.code),
      value: item.count
    }));
    return opts;
  });
  loading.value = false;
}

function getStatusLabel(code: string) {
  return code === '0' ? $t('page.dashboard.normal') : $t('page.dashboard.disabled');
}

watch(days, getData);
onMounted(getData);
</script>

<template>
  <div class="min-h-500px flex-col-stretch gap-16px overflow-hidden lt-sm:overflow-auto">
    <NCard :bordered="false" size="small" class="card-wrapper">
      <div class="flex flex-wrap items-center justify-between gap-16px">
        <div>
          <h2 class="text-18px font-semibold">{{ $t('page.dashboard.analysisTitle') }}</h2>
          <p class="mt-4px text-#999">{{ $t('page.dashboard.analysisDesc') }}</p>
        </div>
        <NSpace align="center">
          <span>{{ $t('page.dashboard.dateRange') }}</span>
          <NSelect v-model:value="days" :options="daysOptions" class="w-140px" />
          <NButton type="primary" :loading="loading" @click="getData">{{ $t('page.dashboard.refresh') }}</NButton>
        </NSpace>
      </div>
    </NCard>

    <NAlert v-if="loadError" type="warning" :title="$t('page.dashboard.loadFailed')">
      {{ $t('page.dashboard.loadFailedDesc') }}
    </NAlert>

    <NGrid cols="1 s:2 m:4" responsive="screen" :x-gap="16" :y-gap="16">
      <NGi v-for="item in summaryCards" :key="item.key">
        <NCard :bordered="false" size="small" class="card-wrapper">
          <div class="text-#999">{{ item.label }}</div>
          <NStatistic class="mt-8px" :value="item.value" />
        </NCard>
      </NGi>
    </NGrid>

    <NGrid cols="1 s:1 m:2" responsive="screen" :x-gap="16" :y-gap="16">
      <NGi>
        <NCard :title="$t('page.dashboard.trendTitle')" :bordered="false" size="small" class="card-wrapper">
          <div ref="trendDomRef" class="h-320px overflow-hidden"></div>
        </NCard>
      </NGi>
      <NGi>
        <NCard :title="$t('page.dashboard.userStatus')" :bordered="false" size="small" class="card-wrapper">
          <div ref="statusDomRef" class="h-320px overflow-hidden"></div>
        </NCard>
      </NGi>
    </NGrid>

    <NCard :title="$t('page.dashboard.detailTitle')" :bordered="false" size="small" class="card-wrapper">
      <NDataTable :columns="trendColumns" :data="summary?.trends || []" :loading="loading" :pagination="false" />
    </NCard>
  </div>
</template>

<style scoped></style>
