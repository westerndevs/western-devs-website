---
title:  Importing Vuetify via ESM
authorId: simon_timms
date: 2023-03-15
originalurl: https://blog.simontimms.com/2023/03/15/vuetify-esm
mode: public
---



If you want a quick way to add Vue 3 and Vuetify to your project via the UMD CDN then you can do so using ESM. ESM are ECMAScript Modules and are now supported by the majority of browsers. This is going to look like 

```html
<script type="importmap">
    { "imports": 
        { "vue": "https://unpkg.com/vue@3.2.47/dist/vue.esm-browser.js" }
          "vuetify": "https://unpkg.com/vuetify@3.1.10/dist/vuetify.esm.js"
        }
</script>
<script type="module">
    import {createApp} from 'vue'
    import { createVuetify } from 'vuetify'
    const vuetify = createVuetify()

    createApp({
      data() {
        return {
          message: 'Hello Vue!'
        }
      }
    }).use(vuetify).mount('#app')
</script>
```

The import map is a way to map a module name to a URL. This is necessary because the Vuetify ESM module imports from Vue. Don't forget you'll also need to add in the CSS for Vuetify