<script setup lang="ts">
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import ProjectDetailView from '../components/ProjectDetailView.vue'
import { projects } from '../data/projects'

const route = useRoute()
const project = computed(() => projects.find((item) => item.id === route.params.id))
</script>

<template>
  <ProjectDetailView v-if="project" :project="project" />
</template>
