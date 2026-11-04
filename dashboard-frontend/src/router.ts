import { createRouter, createWebHistory, type RouteRecordRaw } from 'vue-router'
import { isDemoSession } from './composables/useDemoSession'
import DashboardLayout from './layouts/DashboardLayout.vue'
import DashboardPage from './views/DashboardPage.vue'
import LoginPage from './views/LoginPage.vue'
import ProjectDetailPage from './views/ProjectDetailPage.vue'

const routes: RouteRecordRaw[] = [
  {
    path: '/',
    name: 'login',
    component: LoginPage,
  },
  {
    path: '/',
    component: DashboardLayout,
    meta: { requiresDemo: true },
    children: [
      {
        path: 'dashboard',
        name: 'dashboard',
        component: DashboardPage,
      },
      {
        path: 'projects/:id',
        name: 'project',
        component: ProjectDetailPage,
      },
    ],
  },
  {
    path: '/:pathMatch(.*)*',
    redirect: '/',
  },
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes,
})

router.beforeEach((to) => {
  if (to.meta.requiresDemo && !isDemoSession.value) {
    return { name: 'login' }
  }

  if (to.name === 'login' && isDemoSession.value) {
    return { name: 'dashboard' }
  }
})

export default router
