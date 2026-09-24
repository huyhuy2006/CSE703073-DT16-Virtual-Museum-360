import {
  createRouter,
  createWebHistory,
} from 'vue-router'

const routes = [
  {
    path: '/',
    name: 'home',
    component: () =>
      import('../views/HomeView.vue'),
  },

  {
    path: '/tham-quan-360',
    name: 'museum-360',
    component: () =>
      import('../views/Museum360View.vue'),
  },

  {
    path: '/tour/:tourId',
    name: 'tour-detail',
    component: () =>
      import('../views/TourDetailView.vue'),
    props: true,
  },

  {
    path: '/:pathMatch(.*)*',
    name: 'not-found',
    component: () =>
      import('../views/NotFoundView.vue'),
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,

  scrollBehavior() {
    return {
      top: 0,
    }
  },
})

export default router
