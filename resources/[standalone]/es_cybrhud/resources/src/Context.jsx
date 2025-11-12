import {createContext, useContext} from "react";

const MainContext = createContext()
 
const ClientMessage = (msg, send, iscb, callback) => {
    new Promise(function () {
        const https = new XMLHttpRequest();
        https.open("POST", `https://es_cybrhud/${msg}`);
        https.send(send);
        if (iscb) {
            https.onload = function() {
                if (this.status >= 200 && this.status < 400) {
                    console.log(JSON.stringify(this))
                    callback(this)
                }
            };
        }
    });
};// ${GetParentResourceName()}




// const AddSVG = (svg, set) => {
//     if (svg == 'Ammo') {
//         return (
//             svg içinde de datası
//         )
        
//     }
// }


// let SVG = {
//     Ammo = {
//         svg: ()
//     }
// }


let types = {}
const AddType = (type, svg) =>{
    types = {...types, [type] :  svg}
}
const GetSvg = (type) =>{
    if(types[type]){
        return types[type]
    }
}

AddType('Health_Armour',
    <svg className="SVG" width="286" height="98" viewBox="0 0 286 98" fill="none" xmlns="http://www.w3.org/2000/svg">

        <path d="M242.749 73.0527H89.3359L97.9217 87.4927H245.796L249.922 84.9141L242.749 73.0527Z" fill="#053131" fill-opacity="0.8"/>
        <path d="M265.852 40.1416H21L45.9219 81H87.9219L78.9219 63.8644H276.793L279.372 61.8015L265.852 40.1416Z" fill="#053131" fill-opacity="0.8"/>
        {/* <path d="M148.922 85L144.831 76H140.922L145.016 85H148.922Z" fill="white" fill-opacity="0.8"/>
        <path d="M155.922 85L151.32 76H146.922L151.528 85H155.922Z" fill="white" fill-opacity="0.8"/>
        <path d="M162.922 85L158.32 76H153.922L158.528 85H162.922Z" fill="white" fill-opacity="0.8"/>
        <path d="M169.922 85L165.32 76H160.922L165.528 85H169.922Z" fill="white" fill-opacity="0.8"/>
        <path d="M176.922 85L172.32 76H167.922L172.528 85H176.922Z" fill="white" fill-opacity="0.8"/>
        <path d="M183.922 85L179.32 76H174.922L179.528 85H183.922Z" fill="white" fill-opacity="0.8"/>
        <path d="M190.922 85L186.32 76H181.922L186.528 85H190.922Z" fill="white" fill-opacity="0.8"/>
        <path d="M196.922 85L192.831 76H188.922L193.016 85H196.922Z" fill="white" fill-opacity="0.8"/>
        <path d="M203.922 85L199.32 76H194.922L199.528 85H203.922Z" fill="white" fill-opacity="0.8"/>
        <path d="M244.922 83L240.337 76L201.922 76L206.511 85H241.922L244.922 83Z" fill="white"/> */}
        <g filter="url(#filter0_d_8_429)">
            <path d="M63.9998 63.5789V66.7368H66.9996V68.8421H63.9988L63.9998 72H62L61.999 68.8421H59.0002V66.7368H62V63.5789H63.9998ZM65.2428 53.8495C67.5046 56.2368 67.5826 60.0389 65.4787 62.5179L64.0588 61.0253C65.3897 59.421 65.3197 56.9052 63.8268 55.3368C62.324 53.7589 59.9071 53.6916 58.3372 55.1758L57.0023 56.4368L55.6664 55.1768C54.0915 53.6905 51.6757 53.7558 50.1728 55.3389C48.6829 56.9074 48.6079 59.4179 49.9808 61.0768L58.4122 69.9674L57.0003 71.4579L48.5209 62.5189C46.417 60.0389 46.496 56.2305 48.7569 53.8495C51.0217 51.4663 54.6445 51.3863 57.0003 53.6095C59.3492 51.3895 62.9789 51.4631 65.2418 53.8495H65.2428Z" fill="#2EFFFF"/>
        </g>
        <g filter="url(#filter1_d_8_429)">
            <path fill-rule="evenodd" clip-rule="evenodd" d="M22.4219 37C22.1457 37 21.9219 37.2239 21.9219 37.5C21.9219 37.7761 22.1457 38 22.4219 38H267.152L276.504 52.274C276.655 52.505 276.965 52.5696 277.196 52.4182C277.427 52.2669 277.491 51.957 277.34 51.726L267.692 37H22.4219ZM100.422 70.5C100.146 70.5 99.9219 70.7239 99.9219 71C99.9219 71.2761 100.146 71.5 100.422 71.5H250.922C251.198 71.5 251.422 71.2761 251.422 71C251.422 70.7239 251.198 70.5 250.922 70.5H100.422ZM132.922 89.5C132.922 89.2239 133.146 89 133.422 89H233.422C233.698 89 233.922 89.2239 233.922 89.5C233.922 89.7761 233.698 90 233.422 90H133.422C133.146 90 132.922 89.7761 132.922 89.5ZM37.8412 73.2276C37.6907 72.996 37.381 72.9303 37.1494 73.0808C36.9179 73.2313 36.8522 73.541 37.0027 73.7726L43.6506 84.0001H88.4219C88.6981 84.0001 88.9219 83.7762 88.9219 83.5001C88.9219 83.2239 88.6981 83.0001 88.4219 83.0001H44.1933L37.8412 73.2276Z" fill="#2EFFFF"/>
        </g>
        <path d="M182 34.5H37L54 12.5H192V26.5L182 34.5Z" fill="#053131" fill-opacity="0.8"/>
        <g filter="url(#filter2_d_8_429)">
            <path fill-rule="evenodd" clip-rule="evenodd" d="M182.5 8H51.7512L36.2512 28.5H12.95C12.7184 27.3589 11.7095 26.5 10.5 26.5C9.11929 26.5 8 27.6193 8 29C8 30.3807 9.11929 31.5 10.5 31.5C11.7095 31.5 12.7184 30.6411 12.95 29.5H36.7488L52.2488 9H182.5V8Z" fill="#2EFFFF"/>
        </g>
        <g filter="url(#filter3_d_8_429)">
            <path d="M69.4286 30H68V28.5714C68 28.0031 67.7742 27.4581 67.3724 27.0562C66.9705 26.6543 66.4255 26.4286 65.8571 26.4286H61.5714C61.0031 26.4286 60.4581 26.6543 60.0562 27.0562C59.6543 27.4581 59.4286 28.0031 59.4286 28.5714V30H58V28.5714C58 27.6242 58.3763 26.7158 59.046 26.046C59.7158 25.3763 60.6242 25 61.5714 25H65.8571C66.8043 25 67.7128 25.3763 68.3825 26.046C69.0523 26.7158 69.4286 27.6242 69.4286 28.5714V30ZM63.7143 23.5714C63.1515 23.5714 62.5942 23.4606 62.0742 23.2452C61.5542 23.0298 61.0818 22.7141 60.6838 22.3162C60.2859 21.9182 59.9702 21.4458 59.7548 20.9258C59.5394 20.4058 59.4286 19.8485 59.4286 19.2857C59.4286 18.7229 59.5394 18.1656 59.7548 17.6456C59.9702 17.1257 60.2859 16.6532 60.6838 16.2553C61.0818 15.8573 61.5542 15.5416 62.0742 15.3262C62.5942 15.1109 63.1515 15 63.7143 15C64.8509 15 65.941 15.4515 66.7447 16.2553C67.5485 17.059 68 18.1491 68 19.2857C68 20.4224 67.5485 21.5124 66.7447 22.3162C65.941 23.1199 64.8509 23.5714 63.7143 23.5714V23.5714ZM63.7143 22.1429C64.472 22.1429 65.1988 21.8418 65.7346 21.306C66.2704 20.7702 66.5714 20.0435 66.5714 19.2857C66.5714 18.528 66.2704 17.8012 65.7346 17.2654C65.1988 16.7296 64.472 16.4286 63.7143 16.4286C62.9565 16.4286 62.2298 16.7296 61.694 17.2654C61.1582 17.8012 60.8571 18.528 60.8571 19.2857C60.8571 20.0435 61.1582 20.7702 61.694 21.306C62.2298 21.8418 62.9565 22.1429 63.7143 22.1429V22.1429Z" fill="#2EFFFF"/>
        </g>
        <g transform="translate(19.2 0)" filter="url(#filter4_d_8_429)">
            <path  d="M99.2174 23.4783V24.7826C98.1796 24.7826 97.1843 25.1949 96.4505 25.9287C95.7166 26.6626 95.3043 27.6578 95.3043 28.6957H94C94 27.3119 94.5497 25.9849 95.5281 25.0064C96.5066 24.0279 97.8337 23.4783 99.2174 23.4783V23.4783ZM99.2174 22.8261C97.0554 22.8261 95.3043 21.075 95.3043 18.913C95.3043 16.7511 97.0554 15 99.2174 15C101.379 15 103.13 16.7511 103.13 18.913C103.13 21.075 101.379 22.8261 99.2174 22.8261ZM99.2174 21.5217C100.659 21.5217 101.826 20.3543 101.826 18.913C101.826 17.4717 100.659 16.3043 99.2174 16.3043C97.7761 16.3043 96.6087 17.4717 96.6087 18.913C96.6087 20.3543 97.7761 21.5217 99.2174 21.5217ZM104.975 28.0898L103.13 30L101.286 28.0898C100.267 27.0346 100.267 25.3246 101.286 24.2693C101.524 24.0195 101.81 23.8205 102.127 23.6846C102.444 23.5486 102.785 23.4785 103.13 23.4785C103.475 23.4785 103.817 23.5486 104.134 23.6846C104.451 23.8205 104.737 24.0195 104.975 24.2693C105.994 25.3246 105.994 27.0346 104.975 28.0898V28.0898ZM104.037 27.1833C104.567 26.6341 104.567 25.725 104.037 25.1759C103.921 25.0518 103.78 24.9529 103.624 24.8853C103.469 24.8176 103.3 24.7827 103.13 24.7827C102.96 24.7827 102.792 24.8176 102.636 24.8853C102.48 24.9529 102.34 25.0518 102.224 25.1759C101.694 25.725 101.694 26.6341 102.224 27.1839L103.13 28.1217L104.037 27.1826V27.1833Z" fill="#2EFFFF"/>
        </g>




        <g filter="url(#filter5_d_8_429)">
            <text fill="#FCEE0C" xmlSpace="preserve" style={{whiteSpace: 'pre'}} font-family="Tomorrow" font-size="10" font-weight="500" letter-spacing="0.05em"><tspan x="78.2793" y="27">247</tspan></text>
        </g>

        <g filter="url(#filter7_d_8_429)">
            <text fill="#FCEE0C" xmlSpace="preserve" style={{whiteSpace: 'pre'}} font-family="Tomorrow" font-size="10" font-weight="500" letter-spacing="0.05em"><tspan x="133.396" y="27">254</tspan></text>
        </g>
        <text fill="#FCEE0C" fill-opacity="0.4" xmlSpace="preserve" style={{whiteSpace: 'pre'}} font-family="Tomorrow" font-size="10" font-weight="500" letter-spacing="0.05em"><tspan x="154.255" y="27">/600</tspan></text>




        <defs>
            <filter id="filter0_d_8_429" x="39" y="44" width="36" height="36" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
                <feFlood flood-opacity="0" result="BackgroundImageFix"/>
                <feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>
                <feOffset/>
                <feGaussianBlur stdDeviation="4"/>
                <feComposite in2="hardAlpha" operator="out"/>
                <feColorMatrix type="matrix" values="0 0 0 0 0.180392 0 0 0 0 1 0 0 0 0 1 0 0 0 1 0"/>
                <feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow_8_429"/>
                <feBlend mode="normal" in="SourceGraphic" in2="effect1_dropShadow_8_429" result="shape"/>
            </filter>
            <filter id="filter1_d_8_429" x="13.9219" y="29" width="271.5" height="69" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
                <feFlood flood-opacity="0" result="BackgroundImageFix"/>
                <feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>
                <feOffset/>
                <feGaussianBlur stdDeviation="4"/>
                <feComposite in2="hardAlpha" operator="out"/>
                <feColorMatrix type="matrix" values="0 0 0 0 0.180392 0 0 0 0 1 0 0 0 0 1 0 0 0 1 0"/>
                <feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow_8_429"/>
                <feBlend mode="normal" in="SourceGraphic" in2="effect1_dropShadow_8_429" result="shape"/>
            </filter>
            <filter id="filter2_d_8_429" x="0" y="0" width="190.5" height="39.5" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
                <feFlood flood-opacity="0" result="BackgroundImageFix"/>
                <feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>
                <feOffset/>
                <feGaussianBlur stdDeviation="4"/>
                <feComposite in2="hardAlpha" operator="out"/>
                <feColorMatrix type="matrix" values="0 0 0 0 0.180392 0 0 0 0 1 0 0 0 0 1 0 0 0 1 0"/>
                <feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow_8_429"/>
                <feBlend mode="normal" in="SourceGraphic" in2="effect1_dropShadow_8_429" result="shape"/>
            </filter>
            <filter id="filter3_d_8_429" x="50" y="7" width="27.4285" height="31" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
                <feFlood flood-opacity="0" result="BackgroundImageFix"/>
                <feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>
                <feOffset/>
                <feGaussianBlur stdDeviation="4"/>
                <feComposite in2="hardAlpha" operator="out"/>
                <feColorMatrix type="matrix" values="0 0 0 0 0.180392 0 0 0 0 1 0 0 0 0 1 0 0 0 1 0"/>
                <feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow_8_429"/>
                <feBlend mode="normal" in="SourceGraphic" in2="effect1_dropShadow_8_429" result="shape"/>
            </filter>
            <filter id="filter4_d_8_429" x="86" y="7" width="27.7393" height="31" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
                <feFlood flood-opacity="0" result="BackgroundImageFix"/>
                <feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>
                <feOffset/>
                <feGaussianBlur stdDeviation="4"/>
                <feComposite in2="hardAlpha" operator="out"/>
                <feColorMatrix type="matrix" values="0 0 0 0 0.180392 0 0 0 0 1 0 0 0 0 1 0 0 0 1 0"/>
                <feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow_8_429"/>
                <feBlend mode="normal" in="SourceGraphic" in2="effect1_dropShadow_8_429" result="shape"/>
            </filter>



            <filter id="filter5_d_8_429" x="70.8794" y="11.63" width="33.5396" height="23.37" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
                <feFlood flood-opacity="0" result="BackgroundImageFix"/>
                <feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>
                <feOffset/>
                <feGaussianBlur stdDeviation="4"/>
                <feComposite in2="hardAlpha" operator="out"/>
                <feColorMatrix type="matrix" values="0 0 0 0 0.988235 0 0 0 0 0.933333 0 0 0 0 0.0470588 0 0 0 1 0"/>
                <feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow_8_429"/>
                <feBlend mode="normal" in="SourceGraphic" in2="effect1_dropShadow_8_429" result="shape"/>
            </filter>
            <filter id="filter7_d_8_429" x="125.996" y="11.63" width="35.2114" height="23.37" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
                <feFlood flood-opacity="0" result="BackgroundImageFix"/>
                <feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>
                <feOffset/>
                <feGaussianBlur stdDeviation="4"/>
                <feComposite in2="hardAlpha" operator="out"/>
                <feColorMatrix type="matrix" values="0 0 0 0 0.988235 0 0 0 0 0.933333 0 0 0 0 0.0470588 0 0 0 1 0"/>
                <feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow_8_429"/>
                <feBlend mode="normal" in="SourceGraphic" in2="effect1_dropShadow_8_429" result="shape"/>
            </filter>
        </defs>
    </svg>

)



export {
    MainContext,
    useContext,
    ClientMessage,
    GetSvg
}