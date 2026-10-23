<script setup lang="ts">
import DashboardView from '../components/DashboardView.vue'
import { projects } from '../data/projects'
</script>

<template>
  <DashboardView :projects="projects" />
</template>
