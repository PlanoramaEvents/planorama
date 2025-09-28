<template>
    <div>
        <sidebar-vue v-if="selected" model="venue">
            <template #header>
                <h3>{{ selected.name }}</h3>
                <small class="text-muted d-block">Last updated</small>
                <!-- <small class="text-muted d-block"> by <em><strong>{{selected.updated_by && selected.updated_by.name}}</strong></em></small> -->
                <small class="text-muted d-block"> on <em><strong>{{ new
                    Date(selected.updated_at).toLocaleString()}}</strong></em></small>
            </template>
            <template #content v-if="selected">
                <dl>
                    <dt>Address:</dt>
                    <dd class="ml-2">
                        {{ selected.address }}
                    </dd>
                </dl>
                <div class="float-right d-flex justify-content-end">
                    <b-button title="Edit Venue" variant="primary" :to="editLink"><b-icon-pencil
                            variant="white"></b-icon-pencil></b-button>
                </div>
                <ul>
                    <li v-for="(value, name) in selected">
                        {{ name }}: {{ value }}
                    </li>
                </ul>
            </template>
        </sidebar-vue>
    </div>
</template>

<script>
import SidebarVue from '@/components/sidebar_vue.vue'
import { modelMixinNoProp } from '@/mixins'
export default {
    name: "VenuesSidebar",
    components: { SidebarVue },
    mixins: [modelMixinNoProp],
    data: () => ({ model: "venue" }),
    computed: {
        editLink() {
            return `/venues/edit/venue/${this.selected.id}`;
        },
    }
}
</script>