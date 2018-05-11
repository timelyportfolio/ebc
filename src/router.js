import VueRouter from 'vue-router'
import Home from './components/Home.vue'
import About from './components/About.vue'
import AboutMethod from './components/AboutMethod.vue'
import AboutGroup from './components/AboutGroup.vue'
import AboutTool from './components/AboutTool.vue'
import AboutToolData from './components/AboutToolData.vue'
import AboutToolTool from './components/AboutToolTool.vue'
import AboutToolGlossary from './components/AboutToolGlossary.vue'
import Contact from './components/Contact.vue'
import Explore from './components/Explore.vue'
import ExploreHumanWellBeing from './components/ExploreHumanWellBeing.vue'
import AboutHumanWellBeing from './components/AboutHumanWellBeing.vue'
import WellbeingVis from './components/Vis.vue'
import WellbeingDataTable from './components/DataTable.vue'
import WellbeingDownload from './components/Download.vue'
import ExploreProgramForests from './profor/ExploreProgramForests.vue'
import ProforVis from './profor/components/Vis.vue'
import ProforDataTable from './profor/components/DataTable.vue'
import ProforDownload from './profor/components/Download.vue'
import AboutProfor from './profor/components/AboutProfor.vue'
import ExploreWildlife from './wildlife/components/ExploreWildlife.vue'
import Research from './components/Research.vue'
import ResearchOngoing from './components/ResearchOngoing.vue'
import News from './components/News.vue'
import Register from './components/Registration.vue'

// 1. Define route components.
// These can be imported from other files
//var Register = { template: '<div>register</div>' }

// 2. Define some routes
// Each route should map to a component. The "component" can
// either be an actual component constructor created via
// `Vue.extend()`, or just a component options object.
// We'll talk about nested routes later.
var routes = [
  { path: '/', component: Home },
  { path: '/about', component: About,
      children: [
        {
          path: 'method',
          component: AboutMethod
        },
        {
          path: 'tool',
          component: AboutTool,
          children: [
            {
              path: '',
              redirect: 'data'
            },
            {
              path: 'data',
              component: AboutToolData
            },
            {
              path: 'tool',
              component: AboutToolTool
            },
            {
              path: 'glossary',
              component: AboutToolGlossary
            }
          ]
        },
        {
          path: 'group',
          component: AboutGroup
        }
      ]
  },
  { path: '/contact', component: Contact },
  { path: '/explore', component: Explore,
      children: [
        {
          path: '',
          component: ExploreHumanWellBeing
        },
        {
          path: 'wellbeing',
          component: ExploreHumanWellBeing,
          children: [
            {
              path: '',
              redirect: 'charts'
            },
            {
              path: 'charts',
              component: WellbeingVis
            },
            {
              path: 'tables',
              component: WellbeingDataTable
            },
            {
              path: 'download',
              component: WellbeingDownload
            },
            {
              path: 'about',
              component: AboutHumanWellBeing
            }
          ]
        },
        {
          path: 'wildlife',
          component: ExploreWildlife
        },
        {
          path: 'profor',
          component: ExploreProgramForests,
          children: [
            {
              path: '',
              redirect: 'charts'
            },
            {
              path: 'charts',
              component: ProforVis
            },
            {
              path: 'tables',
              component: ProforDataTable
            },
            {
              path: 'download',
              component: ProforDownload
            },
            {
              path: 'about',
              component: AboutProfor
            }
          ]
        }
      ]
  },
  { path: '/research', component: Research,
      children: [
        {
          path: 'ongoing',
          component: ResearchOngoing
        }
      ]
  },
  { path: '/news', component: News },
  { path: '/register', component: Register}
]

// 3. Create the router instance and pass the `routes` option
// You can pass in additional options here, but let's
// keep it simple for now.
var router = new VueRouter({
  routes: routes//,
  //mode: 'history'
})

export default router
