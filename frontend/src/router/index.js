import {
  createRouter,
  createWebHistory,
} from 'vue-router'

const routes = [
  {
    path: '/',
    name: 'home',
    component: () => import('../views/HomeView.vue'),
  },
  {
    path: '/museum-360',
    name: 'museum-360',
    component: () => import('../views/Museum360View.vue'),
  },
  {
    path: '/tours',
    name: 'tours',
    component: () => import('../views/TourDetailView.vue'),
  },
  {
    path: '/collection',
    name: 'collection',
    component: () => import('../views/CollectionView.vue'),
  },
  {
    path: '/guestbook',
    name: 'guestbook',
    component: () => import('../views/GuestbookView.vue'),
  },
  {
    path: '/:pathMatch(.*)*',
    name: '404',
    component: () => import('../views/NotFoundView.vue'),
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior: () => ({
    top: 0,
  }),
})

export default router
