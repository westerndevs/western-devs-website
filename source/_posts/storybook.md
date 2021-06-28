---
title:  Getting started with Storybook and Vue
# Adding Vuetify
authorId: simon_timms
date: 2021-06-17
originalurl: https://blog.simontimms.com/2021/06/17/storybook
mode: public
---



1. Starting with an empty folder you can run 
    ```
    npx sb init
    ```
2. During the addition you'll be prompted for the template type - select vue
3. If this is brand new then you'll need to install vue. The template assumes you have it installed already. 
    ```
    npm install vue vue-template-compiler
    ```
4. Run storybook with 

    ```
    npm run storybook
    ```
This will get storybook running and you'll be presented with the browser interface for it 
![](/images/2021-04-27-storybook.md/2021-04-27-12-17-47.png))

## Adding Vuetify

1. In the project install vuetify
   ```
   npm install vuetify
   ```
2. In the `.storybook` folder add a `preview-head.html` file. This will be included in the project template. Set the content to 

    ```
    <link href="https://cdn.jsdelivr.net/npm/@mdi/font@4.x/css/materialdesignicons.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/vuetify@2.x/dist/vuetify.min.css" rel="stylesheet">
    ```

3. Create a new file called `vuetify_storybook.js` and add to it 

```javascript
import Vue from 'vue';
import Vuetify from 'vuetify'; // loads all components
import 'vuetify/dist/vuetify.min.css'; // all the css for components
import en from 'vuetify/es5/locale/en';

Vue.use(Vuetify);

export default new Vuetify({
    lang: {
        locales: { en },
        current: 'en'
    }
});
```
4. In the `.storybook` folder add to the `preview.js` and include 

    ```
    import { addDecorator } from '@storybook/vue';
    import vuetify from './vuetify_storybook';

    addDecorator(() => ({
    vuetify,
    template: `
        <v-app>
        <v-main>
            <v-container fluid >
            <story/>
            </v-container>
        </v-main>
        </v-app>
        `,
    }));
    ```
    This will add vuetify wrapping to the project. You can now just go ahead and us the components in your .vue files. Here is an example:
    ```
    <template>
        <div>
            <v-text-field dense label="User name" hint="You can use your email"></v-text-field>
            <v-text-field dense label="Password" hint="You need to use upper case and lower case"></v-text-field>
        </div>
    </template>
    <script>
    module.exports = {
        data: function () {
            return {
            userName: null,
            password: null,
            rememberMe: false,
            };
        },
        computed: {
            isValid: function () {
            return true;
            },
        },
    };
    </script>
    ```

    ## Networking

    If you're using a service layer then you an shim that in to prevent making network calls. However that might not be what you want to do so you can instead shim in something to intercept all network calls. This can be done using the mock service worker addon https://storybook.js.org/addons/msw-storybook-addon

    To get it working install it 
    ```
    npm i -D msw msw-storybook-addon
    ```

    Then to the preview.js file you can add a hook for it

    ```
    import { initializeWorker, mswDecorator } from 'msw-storybook-addon';

    initializeWorker();
    addDecorator(mswDecorator);
    ```
    