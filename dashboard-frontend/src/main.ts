import { createApp } from 'vue'
import App from './App.vue'
import './assets/styles/style.css'
import './assets/styles/auth.css'
import './assets/styles/dashboard.css'
import i18n from './i18n'
import router from './router'

createApp(App).use(i18n).use(router).mount('#app')
