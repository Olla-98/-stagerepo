<script setup lang="ts">
import { useRouter } from 'vue-router'
import AuthView from '../components/AuthView.vue'
import { useDemoSession } from '../demoSession'

const router = useRouter()
const { startDemoSession } = useDemoSession()

function openDemo(email: string, name?: string) {
  startDemoSession(email, name)
  router.push({ name: 'dashboard' })
}
</script>

<template>
  <AuthView @open-demo="openDemo" />
</template>
