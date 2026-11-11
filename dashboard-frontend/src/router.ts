import { createRouter, createWebHistory, type RouteRecordRaw } from 'vue-router'
import { useAuth } from './composables/useAuth'
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
    meta: { requiresAuth: true },
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

router.beforeEach(async (to) => {
  const auth = useAuth()

  if (to.name === 'login' && to.query.error === 'connection') {
    return
  }

  let authenticated = false

  try {
    authenticated = await auth.restoreSession()
  } catch {
    return { name: 'login', query: { error: 'connection' } }
  }

  if (to.meta.requiresAuth && !authenticated) {
    return { name: 'login' }
  }

  if (to.name === 'login' && authenticated) {
    return { name: 'dashboard' }
  }
})

export default router
