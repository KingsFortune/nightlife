import React from 'react'
import { MainContext, useContext } from '../../Context'

import { motion, AnimatePresence } from "framer-motion";
import styled from "styled-components";

import './StatusHud.scss'

const StatusHudClass = styled(motion.div)`
    position: absolute;
    left: 2.1rem;
    bottom: .9rem;
`
    // ${props => {
    //     if (props.Name === "Hunger") {
    //         return `left: 2.1rem;`
    //     } else if (props.Name === "Thirst") {
    //         return `left: 5.4rem;`
    //     } else if (props.Name === "oxygen") {
    //         return `left: 8.6rem;`
    //     } else if (props.Name === "breath") {
    //         return `left: 11.9rem;`
    //     }
    // }}

// import { connect } from 'react-redux' isMap

export const StatusHud = (props) => {
    const { isMap, isStamina, isStress, isHunger, isThirst, isGunAnim } = useContext(MainContext);

  return (
    <div className="StatusHud" style={isGunAnim ? {animation: `ShotScales .3s ease-out forwards`} : {animation: ``}}>

        <svg style={isMap ? {bottom: '-2rem'} : {bottom: '.5rem'}} className="StatusHudSVG" width="14.625rem" height="1.75rem" viewBox="0 0 234 28" fill="none" xmlns="http://www.w3.org/2000/svg">
            <g filter="url(#filter0_d_8_566)">
                <path fill-rule="evenodd" clip-rule="evenodd" d="M12.95 11C12.7184 12.1411 11.7095 13 10.5 13C9.11929 13 8 11.8807 8 10.5C8 9.11929 9.11929 8 10.5 8C11.7095 8 12.7184 8.85888 12.95 10H24.2591L30.2591 18.5H225C225.276 18.5 225.5 18.7239 225.5 19C225.5 19.2761 225.276 19.5 225 19.5H29.7409L23.7409 11H12.95Z" fill="#2EFFFF"/>
            </g>
            <defs>
                    <filter id="filter0_d_8_566" x="0" y="0" width="233.5" height="27.5" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
                        <feFlood flood-opacity="0" result="BackgroundImageFix"/>
                        <feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>
                        <feOffset/>
                        <feGaussianBlur stdDeviation="4"/>
                        <feComposite in2="hardAlpha" operator="out"/>
                        <feColorMatrix type="matrix" values="0 0 0 0 0.180392 0 0 0 0 1 0 0 0 0 1 0 0 0 1 0"/>
                        <feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow_8_566"/>
                        <feBlend mode="normal" in="SourceGraphic" in2="effect1_dropShadow_8_566" result="shape"/>
                    </filter>
            </defs>
        </svg>


        <StatusHudClass Name="Hunger" animate={isMap ? {left: '1.1rem', bottom: '1.46rem'} : {left: '2.75rem', bottom: '1.45rem'}}> {/* animate={} */}
            <StatusSVG Load={isHunger}/>
            <svg className='Icon' width="2.125rem" height="2rem" viewBox="0 0 34 32" fill="none" xmlns="http://www.w3.org/2000/svg">
                <g filter="url(#filter0_d_8_536)">
                    <path d="M9.37986 19.2045V20.9215C9.37986 22.619 10.7458 24 12.4249 24H21.5763C23.2547 24 24.6202 22.6189 24.6202 20.9215V19.2045C25.4191 18.8904 26 17.9577 26 16.8588C26 15.7473 25.4045 14.8064 24.5905 14.5042C24.4328 12.7956 23.6406 11.221 22.319 10.0171C20.891 8.71639 19.002 8 17.0002 8C14.9981 8 13.1091 8.71639 11.6809 10.0171C10.3593 11.2208 9.56703 12.7956 9.40944 14.5042C8.59551 14.8064 8 15.7473 8 16.8588C8 17.9578 8.58092 18.8904 9.37986 19.2045ZM23.4372 20.9215C23.4372 21.791 22.585 22.5253 21.5764 22.5253H12.425C11.4157 22.5253 10.563 21.7909 10.563 20.9215V19.3178H23.4372V20.9215ZM17.0002 9.47475C20.2654 9.47475 22.9686 11.6259 23.3808 14.402H10.6193C11.0315 11.6258 13.7349 9.47475 17.0002 9.47475ZM9.97143 15.8766H24.0287C24.4633 15.8766 24.8169 16.3172 24.8169 16.8588C24.8169 17.4016 24.4633 17.8432 24.0287 17.8432H9.97143C9.53674 17.8432 9.18314 17.4017 9.18314 16.8588C9.18314 16.3172 9.53674 15.8766 9.97143 15.8766Z" fill="#FCEE0C"/>
                    <path d="M19.7736 11.146C19.4163 11.146 19.1255 11.5122 19.1255 11.9623C19.1255 12.4094 19.4162 12.7731 19.7736 12.7731C20.1304 12.7731 20.4206 12.4094 20.4206 11.9623C20.4206 11.5122 20.1304 11.146 19.7736 11.146Z" fill="#FCEE0C"/>
                    <path d="M16.2277 11.146C15.8711 11.146 15.5808 11.5122 15.5808 11.9623C15.5808 12.4094 15.8711 12.7731 16.2277 12.7731C16.5843 12.7731 16.8746 12.4094 16.8746 11.9623C16.8746 11.5122 16.5843 11.146 16.2277 11.146Z" fill="#FCEE0C"/>
                    <path d="M21.5461 12.3643C21.1899 12.3643 20.9001 12.7306 20.9001 13.1808C20.9001 13.6281 21.1899 13.9919 21.5461 13.9919C21.9027 13.9919 22.1931 13.6281 22.1931 13.1808C22.1931 12.7305 21.9027 12.3643 21.5461 12.3643Z" fill="#FCEE0C"/>
                    <path d="M17.9996 12.3643C17.6436 12.3643 17.354 12.7306 17.354 13.1808C17.354 13.6281 17.6436 13.9919 17.9996 13.9919C18.3558 13.9919 18.6457 13.6281 18.6457 13.1808C18.6457 12.7305 18.3558 12.3643 17.9996 12.3643Z" fill="#FCEE0C"/>
                    <path d="M14.4542 12.3643C14.0982 12.3643 13.8086 12.7306 13.8086 13.1808C13.8086 13.6281 14.0982 13.9919 14.4542 13.9919C14.811 13.9919 15.1013 13.6281 15.1013 13.1808C15.1012 12.7305 14.811 12.3643 14.4542 12.3643Z" fill="#FCEE0C"/>
                </g>
                <defs>
                    <filter id="filter0_d_8_536" x="0" y="0" width="34" height="32" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
                        <feFlood flood-opacity="0" result="BackgroundImageFix"/>
                        <feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>
                        <feOffset/>
                        <feGaussianBlur stdDeviation="4"/>
                        <feComposite in2="hardAlpha" operator="out"/>
                        <feColorMatrix type="matrix" values="0 0 0 0 0.988235 0 0 0 0 0.933333 0 0 0 0 0.0470588 0 0 0 1 0"/>
                        <feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow_8_536"/>
                        <feBlend mode="normal" in="SourceGraphic" in2="effect1_dropShadow_8_536" result="shape"/>
                    </filter>
                </defs>
            </svg>
        </StatusHudClass>

        <StatusHudClass Name="Thirst" animate={isMap ? {left: '1.1rem', bottom: '4.68rem'} : {left: '6rem', bottom: '1.45rem'}}>
            <StatusSVG Load={isThirst}/>
            <svg className='Icon' style={{top:'-.25rem'}} width="1.875rem" height="2rem" viewBox="0 0 30 32" fill="none" xmlns="http://www.w3.org/2000/svg">
                <g filter="url(#filter0_d_8_549)">
                    <path d="M14.6274 10.0825L10.9823 13.7276C10.2615 14.4485 9.77062 15.3669 9.57177 16.3668C9.37292 17.3667 9.47503 18.4031 9.86519 19.345C10.2553 20.2869 10.916 21.0919 11.7637 21.6582C12.6114 22.2246 13.6079 22.5269 14.6274 22.5269C15.6469 22.5269 16.6435 22.2246 17.4911 21.6582C18.3388 21.0919 18.9995 20.2869 19.3897 19.345C19.7798 18.4031 19.8819 17.3667 19.6831 16.3668C19.4842 15.3669 18.9933 14.4485 18.2725 13.7276L14.6274 10.0825ZM14.6274 8L19.3137 12.6863C20.2406 13.6132 20.8718 14.7941 21.1275 16.0797C21.3832 17.3653 21.252 18.6978 20.7503 19.9088C20.2487 21.1198 19.3993 22.1549 18.3094 22.8831C17.2195 23.6113 15.9382 24 14.6274 24C13.3166 24 12.0353 23.6113 10.9454 22.8831C9.85556 22.1549 9.00611 21.1198 8.50449 19.9088C8.00288 18.6978 7.87163 17.3653 8.12734 16.0797C8.38305 14.7941 9.01425 13.6132 9.9411 12.6863L14.6274 8ZM10.9455 17.3726H18.3093C18.3093 18.3491 17.9214 19.2856 17.2309 19.9761C16.5404 20.6666 15.6039 21.0545 14.6274 21.0545C13.6509 21.0545 12.7144 20.6666 12.0239 19.9761C11.3334 19.2856 10.9455 18.3491 10.9455 17.3726Z" fill="#FCEE0C"/>
                </g>
                <defs>
                    <filter id="filter0_d_8_549" x="0" y="0" width="29.2549" height="32" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
                        <feFlood flood-opacity="0" result="BackgroundImageFix"/>
                        <feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>
                        <feOffset/>
                        <feGaussianBlur stdDeviation="4"/>
                        <feComposite in2="hardAlpha" operator="out"/>
                        <feColorMatrix type="matrix" values="0 0 0 0 0.988235 0 0 0 0 0.933333 0 0 0 0 0.0470588 0 0 0 1 0"/>
                        <feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow_8_549"/>
                        <feBlend mode="normal" in="SourceGraphic" in2="effect1_dropShadow_8_549" result="shape"/>
                    </filter>
                </defs>
            </svg>
        </StatusHudClass>

        <StatusHudClass Name="oxygen" animate={isMap ? {left: '1.1rem', bottom: '7.95rem'} : {left: '9.25rem', bottom: '1.45rem'}}>
            <StatusSVG Load={isStress}/>
            <svg className='Icon' width="2rem" height="2rem" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
                <g filter="url(#filter0_d_8_556)">
                    <path d="M24 14.0623C24 12.6167 23.0162 11.3701 21.6182 10.9264C21.5338 9.29918 20.1065 8 18.3639 8C17.4473 8 16.6011 8.35919 16 8.95809C15.3989 8.35919 14.5527 8 13.6361 8C11.8935 8 10.4662 9.29918 10.3819 10.9264C8.98389 11.3701 8 12.6167 8 14.0623C8 14.8086 8.26294 15.5199 8.73838 16.0954C8.35675 16.6333 8.15225 17.265 8.15225 17.93C8.15225 19.3202 9.05542 20.5282 10.3794 21.0131C10.431 22.6685 11.8721 24 13.6361 24C14.5527 24 15.3989 23.6408 16.0001 23.0419C16.6011 23.6408 17.4474 24 18.3639 24C20.1279 24 21.569 22.6685 21.6206 21.0132C22.9446 20.5282 23.8478 19.3203 23.8478 17.93C23.8478 17.265 23.6433 16.6333 23.2616 16.0955C23.737 15.5199 24 14.8086 24 14.0623ZM15.2304 21.5263C14.9703 22.1397 14.3433 22.5454 13.6361 22.5454C12.6883 22.5454 11.9172 21.8168 11.9172 20.9211C11.9172 20.8186 11.9277 20.7145 11.9487 20.6117C11.9489 20.6106 11.949 20.6095 11.9492 20.6084C12.0146 20.2913 12.1775 20.0023 12.4206 19.7724C12.7212 19.4884 12.7212 19.028 12.4206 18.7439C12.1201 18.4599 11.6328 18.4599 11.3323 18.7439C11.0779 18.9844 10.87 19.2594 10.7137 19.5587C10.097 19.2424 9.69148 18.6273 9.69148 17.93C9.69148 17.4179 9.90825 16.9409 10.3019 16.5869C10.3043 16.5847 10.3064 16.5822 10.3088 16.5799C10.6741 16.2548 11.1513 16.0756 11.6537 16.0756H12.9215C13.3465 16.0756 13.6911 15.75 13.6911 15.3484C13.6911 14.9467 13.3465 14.6211 12.9215 14.6211H11.6538C11.0162 14.6211 10.4018 14.7833 9.86532 15.0852C9.6548 14.7853 9.53922 14.4316 9.53922 14.0623C9.53922 13.1194 10.2855 12.3277 11.2753 12.2207C11.4866 12.1978 11.6785 12.0934 11.8054 11.9321C11.9323 11.7707 11.9829 11.567 11.9452 11.3692C11.9266 11.2716 11.9172 11.1739 11.9172 11.0789C11.9171 10.1833 12.6882 9.45462 13.6361 9.45462C14.3433 9.45462 14.9703 9.86031 15.2304 10.4738V21.5263H15.2304ZM19.0786 16.0757H20.3463C20.8487 16.0757 21.3258 16.2548 21.691 16.5798C21.6935 16.582 21.6956 16.5847 21.6982 16.587C22.0918 16.941 22.3086 17.418 22.3086 17.9301C22.3086 18.6273 21.9031 19.2424 21.2864 19.5587C21.1301 19.2593 20.9222 18.9843 20.6678 18.7439C20.3672 18.4599 19.8799 18.4599 19.5794 18.7439C19.2789 19.028 19.2789 19.4885 19.5795 19.7724C19.8224 20.002 19.9853 20.2908 20.0507 20.6077C20.051 20.609 20.051 20.6104 20.0514 20.6117C20.0723 20.7144 20.0829 20.8185 20.0829 20.921C20.0829 21.8167 19.3118 22.5454 18.364 22.5454C17.6568 22.5454 17.0298 22.1397 16.7697 21.5262V10.4737C17.0298 9.86022 17.6567 9.45453 18.3639 9.45453C19.3117 9.45453 20.0828 10.1832 20.0828 11.0789C20.0828 11.1741 20.0734 11.2718 20.0549 11.3692C20.0172 11.567 20.0677 11.7707 20.1947 11.9321C20.3216 12.0934 20.5135 12.1978 20.7248 12.2207C21.7145 12.3278 22.4608 13.1195 22.4608 14.0623C22.4608 14.4316 22.3452 14.7853 22.1347 15.0853C21.5982 14.7834 20.9839 14.6212 20.3463 14.6212H19.0785C18.6535 14.6212 18.3089 14.9468 18.3089 15.3485C18.309 15.7501 18.6535 16.0757 19.0786 16.0757Z" fill="#FCEE0C"/>
                </g>
                <defs>
                    <filter id="filter0_d_8_556" x="0" y="0" width="32" height="32" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
                        <feFlood flood-opacity="0" result="BackgroundImageFix"/>
                        <feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>
                        <feOffset/>
                        <feGaussianBlur stdDeviation="4"/>
                        <feComposite in2="hardAlpha" operator="out"/>
                        <feColorMatrix type="matrix" values="0 0 0 0 0.988235 0 0 0 0 0.933333 0 0 0 0 0.0470588 0 0 0 1 0"/>
                        <feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow_8_556"/>
                        <feBlend mode="normal" in="SourceGraphic" in2="effect1_dropShadow_8_556" result="shape"/>
                    </filter>
                </defs>
            </svg>
        </StatusHudClass>

        <StatusHudClass Name="breath" animate={isMap ? {left: '1.1rem', bottom: '11.25rem'} : {left: '12.5rem', bottom: '1.45rem'}}>
            <StatusSVG Load={isStamina}/>
            <svg className='Icon' width="2rem" height="2rem" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
                <g filter="url(#filter0_d_8_565)">
                    <path fill-rule="evenodd" clip-rule="evenodd" d="M15.3333 18.3859C15.3331 18.4101 15.333 18.4335 15.333 18.4561C15.333 20.5614 14.6664 22.6667 11.9999 22.6667C10.6894 22.6667 10.023 22.6667 9.68406 22.3335C9.33334 21.9887 9.33334 21.2872 9.33334 19.8596C9.33334 14.5965 11.6666 11.0877 13.6665 11.7895C13.7856 11.8312 13.8965 11.8867 13.9997 11.9544C14.7113 12.4214 15.0553 13.4702 15.2177 14.6126L12.2025 16.4449L12.8692 17.6603L15.3424 16.1579C15.3516 16.4433 15.3544 16.7207 15.3539 16.9825C15.3533 17.2457 15.3494 17.493 15.3451 17.7163C15.3438 17.7825 15.3425 17.8465 15.3412 17.9083C15.3375 18.0889 15.3342 18.2498 15.3333 18.3859ZM16 21.7012C15.9367 21.8247 15.8678 21.9459 15.7928 22.0642C15.0285 23.2711 13.7516 24 11.9999 24C11.9765 24 11.9533 24 11.93 24C11.3239 24.0001 10.7569 24.0001 10.3034 23.9471C9.83564 23.8924 9.19485 23.755 8.69997 23.2341C8.21843 22.7272 8.09819 22.0881 8.04904 21.6224C7.9999 21.1568 7.99995 20.5705 8 19.9258C8.00001 19.9038 8.00001 19.8818 8.00001 19.8596C8.00001 17.0512 8.6193 14.6162 9.59443 12.9225C10.0797 12.0796 10.6951 11.3486 11.439 10.8836C12.1813 10.4197 13.0813 10.2119 13.9997 10.4956V9.33333C13.9997 8.59695 14.5967 8 15.333 8H16.6663C17.4027 8 17.9996 8.59695 17.9996 9.33333V10.4959C18.9183 10.2118 19.8185 10.4195 20.561 10.8836C21.3049 11.3486 21.9203 12.0796 22.4056 12.9225C23.3807 14.6162 24 17.0512 24 19.8596V20.1674C23.9992 20.7697 23.9949 21.3367 23.9298 21.7978C23.8641 22.2635 23.7063 22.8747 23.1894 23.3426C22.6932 23.7917 22.0838 23.9066 21.6391 23.9535C21.1981 24.0001 20.6506 24.0001 20.0628 24L20.0001 24C18.2484 24 16.9715 23.2711 16.2072 22.0642C16.1322 21.9459 16.0633 21.8247 16 21.7012ZM16.6667 18.3859C16.6669 18.4101 16.667 18.4335 16.667 18.4561C16.667 20.5614 17.3336 22.6667 20.0001 22.6667C22.5667 22.6667 22.6633 22.6667 22.6667 20.1656V19.8596C22.6667 14.5965 20.3335 11.0877 18.3336 11.7895C18.2141 11.8314 18.103 11.8871 17.9996 11.9551C17.2885 12.4226 16.9447 13.4706 16.7823 14.6133L19.7975 16.4449L19.1308 17.6603L16.6576 16.1586C16.6484 16.4437 16.6456 16.721 16.6461 16.9825C16.6467 17.2459 16.6506 17.4934 16.655 17.7169C16.6562 17.7831 16.6576 17.8472 16.6588 17.909C16.6625 18.0894 16.6658 18.2501 16.6667 18.3859ZM16.6663 15.6491V9.33333H15.333V15.6491H16.6663Z" fill="#FCEE0C"/>
                </g>
                <defs>
                    <filter id="filter0_d_8_565" x="0" y="0" width="32" height="32" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
                        <feFlood flood-opacity="0" result="BackgroundImageFix"/>
                        <feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>
                        <feOffset/>
                        <feGaussianBlur stdDeviation="4"/>
                        <feComposite in2="hardAlpha" operator="out"/>
                        <feColorMatrix type="matrix" values="0 0 0 0 0.988235 0 0 0 0 0.933333 0 0 0 0 0.0470588 0 0 0 1 0"/>
                        <feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow_8_565"/>
                        <feBlend mode="normal" in="SourceGraphic" in2="effect1_dropShadow_8_565" result="shape"/>
                    </filter>
                </defs>
            </svg>
        </StatusHudClass>

    </div>
  )
}


const StatusSVG = (props) => (
    <>
    <svg width="2.188rem" height="2.125rem" viewBox="0 0 35 34" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M34.4142 9.05241L33.0448 7.81394L33.0448 3.94707L33.6935 3.35902L33.6935 1.50511e-06L23.5494 1.94853e-06L21.7656 1.62159L17.2071 1.6216L12.6576 1.6216L10.8738 2.50259e-06L0.729724 2.94601e-06L0.729724 3.35902L1.36936 3.93816L1.36936 7.81394L-1.09049e-06 9.05241L-9.54182e-07 12.1709L-9.05889e-07 13.2757L1.36936 14.5231L1.36936 17.2049L1.36936 19.8868L-5.61994e-07 21.1431L-5.30058e-07 21.8737L-3.93357e-07 25.001L1.36936 26.2395L1.36936 30.1064L0.729725 30.6944L0.729725 34L10.8738 34L12.6576 32.2715L17.2071 32.2715L21.7656 32.2715L23.5494 34L33.6935 34L33.6935 30.6944L33.0448 30.1153L33.0448 26.2395L34.4142 25.001L34.4142 24.9832L34.4142 21.8737L34.4142 20.7778L33.0448 19.5304L33.0448 16.8485L33.0448 14.1578L34.4142 12.9104L34.4142 12.1709L34.4142 9.07023L34.4142 9.05241Z" fill="#053131" fill-opacity="0.8"/>
        <mask id="mask0_101_153" style={{maskType:'alpha'}} maskUnits="userSpaceOnUse" x="0" y="0" width="100%" height="100%">
            <path d="M34.4142 9.05241L33.0448 7.81394L33.0448 3.94707L33.6935 3.35902L33.6935 1.50511e-06L23.5494 1.94853e-06L21.7656 1.62159L17.2071 1.6216L12.6576 1.6216L10.8738 2.50259e-06L0.729724 2.94601e-06L0.729724 3.35902L1.36936 3.93816L1.36936 7.81394L-1.09049e-06 9.05241L-9.54182e-07 12.1709L-9.05889e-07 13.2757L1.36936 14.5231L1.36936 17.2049L1.36936 19.8868L-5.61994e-07 21.1431L-5.30058e-07 21.8737L-3.93357e-07 25.001L1.36936 26.2395L1.36936 30.1064L0.729725 30.6944L0.729725 34L10.8738 34L12.6576 32.2715L17.2071 32.2715L21.7656 32.2715L23.5494 34L33.6935 34L33.6935 30.6944L33.0448 30.1153L33.0448 26.2395L34.4142 25.001L34.4142 24.9832L34.4142 21.8737L34.4142 20.7778L33.0448 19.5304L33.0448 16.8485L33.0448 14.1578L34.4142 12.9104L34.4142 12.1709L34.4142 9.07023L34.4142 9.05241Z" fill="#053131" fill-opacity="0.8"/>
        </mask>
        <g mask="url(#mask0_101_153)">
            <rect y="34" width={props.Load+'%'} height="100%" transform="rotate(-90 0 34)" fill="#2EFFFF" fill-opacity="0.4"/>
        </g>
    </svg>

    <svg style={{position: 'absolute', left:'-.56rem', top:'-.56rem'}}  width="3.25rem" height="3.25rem" viewBox="0 0 52 52" fill="none" xmlns="http://www.w3.org/2000/svg">
            <g filter="url(#filter0_d_101_163)">
                <path fill-rule="evenodd" clip-rule="evenodd" d="M28.0786 9.58467L29.5437 8H30.5378L28.5303 10.1784H25.8189H23.1067L21.0992 8H22.0977L23.5584 9.58467H25.8189H28.0786ZM8.8543 42.465H12.1933L12.7821 41.8216H16.6941L17.9431 43.191H21.0992L20.3547 44H15.7177L14.9618 43.1742H8.5625H8V43.1V42.465V30.7768L9.74375 28.9909V26.0022V23.0091L8 21.2232V9.53501V9.09116V8.9V8.82573H8.55986H14.9601L15.7203 8H20.3583L21.0992 8.80903H17.9466L16.6924 10.1784H12.7839L12.1915 9.53501H8.8543V19.6697L10.5972 21.4512V26.0022V30.5488L8.8543 32.3347V42.465ZM23.9214 42.4154L22.4562 44H21.4622L23.4696 41.8216H26.1811H28.8933L30.9008 44H29.9023L28.4416 42.4154H26.1811H23.9214ZM39.8085 42.465H43.1967V32.3347L41.5575 30.5488V26.0022V21.4512L43.1967 19.6697V9.53501H39.8067L39.2178 10.1784H35.3058L34.0569 8.80903H30.9008L31.6452 8H36.2823L37.0381 8.82573H43.4375H44V8.9V9.53501V21.2232L42.3599 23.0091V26.0022V28.9909L44 30.7768V42.465V42.9088V43.1V43.1742H43.4401H37.0399L36.2797 44H31.6417L30.9008 43.191H34.0534L35.3076 41.8216H39.2161L39.8085 42.465Z" fill="#2EFFFF"/>
            </g>
            <defs>
                <filter id="filter0_d_101_163" x="0" y="0" width="52" height="52" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
                    <feFlood flood-opacity="0" result="BackgroundImageFix"/>
                    <feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>
                    <feOffset/>
                    <feGaussianBlur stdDeviation="4"/>
                    <feComposite in2="hardAlpha" operator="out"/>
                    <feColorMatrix type="matrix" values="0 0 0 0 0.180392 0 0 0 0 1 0 0 0 0 1 0 0 0 1 0"/>
                    <feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow_101_163"/>
                    <feBlend mode="normal" in="SourceGraphic" in2="effect1_dropShadow_101_163" result="shape"/>
                </filter>
            </defs>
    </svg>
    </>
)




// const mapStateToProps = (state) => ({})

// const mapDispatchToProps = {}

// export default connect(mapStateToProps, mapDispatchToProps)(StatusHud)