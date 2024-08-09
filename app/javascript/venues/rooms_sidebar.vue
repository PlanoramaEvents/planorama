<template>
    <div>
        <sidebar-vue v-if="selected" model="room">
            <template #header>
                <h3>{{ selected.name }}</h3>
                <small class="text-muted d-block">Last updated</small>
                <!-- <small class="text-muted d-block"> by <em><strong>{{selected.updated_by && selected.updated_by.name}}</strong></em></small> -->
                <small class="text-muted d-block"> on <em><strong>{{ new
                    Date(selected.updated_at).toLocaleString()}}</strong></em></small>
            </template>
            <template #content v-if="selected">
                <dl>
                    <dt>Is Virtual:</dt>
                    <dd class="ml-2">
                        {{ selected.is_virtual }}
                    </dd>
                    <dt>Open for Scheduling:</dt>
                    <dd class="ml-2">
                        {{ selected.open_for_schedule }}
                    </dd>
                    <dt>Description:</dt>
                    <dd class="ml-2">
                        {{ selected.purpose }}
                    </dd>
                    <dt>Area:</dt>
                    <dd class="ml-2">
                        {{ selected.area_of_space }}
                    </dd>
                    <dt>Ceiling Height:</dt>
                    <dd class="ml-2">
                        {{ selected.height }}
                    </dd>
                    <dt>Length:</dt>
                    <dd class="ml-2">
                        {{ selected.length }}
                    </dd>
                    <dt>Width:</dt>
                    <dd class="ml-2">
                        {{ selected.width }}
                    </dd>
                    <dt>Capacity:</dt>
                    <dd class="ml-2">
                        {{ selected.capacity }}
                    </dd>
                    <dt>Floor:</dt>
                    <dd class="ml-2">
                        {{ selected.floor }}
                    </dd>
                    <dt>Venue:</dt>
                    <dd class="ml-2">
                        {{ selected.venue_id }}
                    </dd>
                </dl>
                <div class="float-right d-flex justify-content-end">
                    <b-button title="Edit Room" variant="primary" :to="editLink"><b-icon-pencil
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
    name: "RoomsSidebar",
    components: { SidebarVue },
    mixins: [modelMixinNoProp],
    data: () => ({ model: "room" }),
    computed: {
        editLink() {
            return `/venues/edit/room/${this.selected.id}`;
        },
    }
}
</script>