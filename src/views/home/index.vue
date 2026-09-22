<script setup lang="ts">
import { onMounted } from 'vue';
import { useRouterPush } from '@/hooks/common/router';

defineOptions({
  name: 'HomeRedirect'
});

const { routerPushByKey } = useRouterPush();

onMounted(() => {
  routerPushByKey('dashboard_workbench');
});
</script>

<template>
  <div class="size-full flex-center">
    <NSpin />
  </div>
</template>

<style scoped></style>
