import React, {useState, useEffect} from 'react';
import { MainContext, ClientMessage, GetSvg, useContext } from '../Context'
import { motion } from "framer-motion";
import './App.scss'
// import './PlayerHud.scss'

import styled from "styled-components";
import { StatusHud } from './StatusHud/StatusHud';
import GunHud from './GunHud/GunHud';
import CarHud from './CarHud/CarHud';


const App = () => {
  const [isOpen, setOpen] = useState(false)

  const [isGunOpen, setGunOpen] = useState(false)
  const [isGunData, setGunData] = useState({
    Ammo: '',
    Clip: ''
  })

  const [isMap, setMap] = useState(true)
  
  const [isLang, setLang] = useState({
    Characteristics: 'characteristics of the weapon',
    Rate: 'Rate',
    Damage: 'Damage',
    Accuracy: 'Accuracy',
  })

  
  const [isGunAnim, setGunAnim] = useState(false)




  const [isHealth, setHealth] = useState(0)
  const [isArmour, setArmour] = useState(0)
  const [isStamina, setStamina] = useState(100)
  const [isStress, setUpdateStress] = useState(0)

  const [isHunger, setHunger] = useState(0)
  const [isThirst, setThirst] = useState(0)


  const [isID, setID] = useState(0)
  const [isMaxPlayer, setMaxPlayer] = useState(0)
  const [isOnlinePlayer, setOnlinePlayer] = useState(0)
  
  const [isFuel, setFuel] = useState(0)
  const [isSpeed, setSpeed] = useState(0)

  const [isSpeedType, setSpeedType] = useState('')
  const [isStreet, setStreet] = useState('')


  const [isMoney, setMoney] = useState(0)
  const [isBankMoney, setBankMoney] = useState(0)
  const [isJobName, setJobName] = useState('')
  
  
  const [isEngine, setEngine] = useState(false)
  const [isSeatbelt, setSeatbelt] = useState(false)
  const [isLight, setLight] = useState(false)
  const [isCruise, setCruise] = useState(false)
  
  
  const [isVoice, setVoice] = useState(false)
  const [isVoiceRange, setVoiceRange] = useState(1)
  // const [isOpenNitro, setOpenNitro] = useState(false);
  const [isNitro, setNitro] = useState(5);

  const Data = {isMap, isGunAnim,
    isArmour, isHealth, isStamina, isStress, isHunger, isThirst,
    isID, isMaxPlayer, isOnlinePlayer, isFuel, isSpeed, isSpeedType, isStreet,
    isGunOpen, isMoney, isBankMoney, isJobName, isEngine, isSeatbelt, isLight, isCruise,
    isNitro, isVoice, isVoiceRange, isGunData
  }

  useEffect(() => {
    const SendNUIMessage = (event) => {
      const { action, data } = event.data;
      if (action === 'setOpen') {
        setOpen(data)
      } else if (action === 'setVoiceRange') {
        setVoiceRange(data)
      } else if (action === 'setVoice') {
        setVoice(data)
      } else if (action === 'setNitro') {
        // setOpenNitro(data.setOpen)
        setNitro(data)
      } else if (action === 'setData') {
        setID(data.ID)
        setMaxPlayer(data.MaxPlayer)
        setSpeedType(data.SpeedType)
      } else if (action === 'setMoney') {
        setMoney(data)
      } else if (action === 'setBankMoney') {
        setBankMoney(data)
      } else if (action === 'setUpdateJob') {
        setJobName(data)
      } else if (action === 'setCruise') {
        setCruise(data)
      } else if (action === 'Speed') {
        setSpeed(data.Speed)
        setFuel(data.Fuel)
        setEngine(data.Engine)
        setSeatbelt(data.Seatbelt)
        setLight(data.Light)
      } else if (action === 'setStreet') {
        setStreet(data.StreetName1 + ' - ' + data.StreetName2)
      } else if (action === 'setCarHud') {
        setMap(data)
      } else if (action === 'setOnlinePlayer') {
        setOnlinePlayer(data)
      } else if (action === 'setHealth') {
        setHealth(data)
      } else if (action === 'setArmour') {
        setArmour(data)
      } else if (action === 'setStamina') {
        setStamina(data)
      } else if (action === 'setUpdateStress') {
        setUpdateStress(data)
      } else if (action === 'setUpdateNeeds') {
        setHunger(data.Hunger)
        setThirst(data.Thirst)
      } else if (action === 'setGunOpen') {
        if (!data) {
          setGunOpen(data)
        } else {
          setGunOpen(data.set)
          setGunData({Ammo: data.Ammo, Clip: data.Clip, Max: data.Load })
          // setGunOpen(data.set) // Ammo - Clip

        }
      } else if (action === 'setGunAnim') {
        if (!isGunAnim) {
          setGunAnim(data)
          setTimeout(() => {
            setGunAnim(false)
          }, 250);
        }
      } else if (action === 'setThirst') {
        setThirst(data)
      } else if (action === 'setHunger') {
        setHunger(data)
      }
    }

    const SendNUIKeydown = (event) => {
      if (event.keyCode == 27) { // escape
        ClientMessage('Close', JSON.stringify(), true, function(is) {
          if (is) {
            setOpen(false)
          }
        })
        // ClientMessage("Close")
      }
    }

    window.addEventListener("message", SendNUIMessage);
    window.addEventListener('keydown', SendNUIKeydown);
    return () => {
      window.removeEventListener("message", SendNUIMessage)
      window.removeEventListener('keydown', SendNUIKeydown);
    };
  });

  return (
    <MainContext.Provider value={Data}>
      <motion.div className="Main" animate={isOpen ? { opacity:1 } : { opacity:0 }}>

        <CarHud/>

        <PlayerHud/>
        <PlayerHudInfo/>
        <Voice/>
        <Map/>

        <GunHud/>
        <StatusHud/>
        <div className="Test"></div>
      </motion.div>
    </MainContext.Provider>
  );
}

export default App;


// ? PlayerHud

// ${props => props.left ? `left: .55rem;` : `right: 0;`}
const PlayerHudClass = styled.div`
  position: absolute;
  height: 7rem;
  width: 19rem;
  ${props => props.left ? "left: 0;" : "right: 0;" }
  top: 0;
  .SVG {
    position: absolute;
    top: .5rem;
    ${props => props.left ? "left: .55rem;" : "right: 0;" }
  }
  .HealthText {
    position: absolute;
    left: 14.43rem;
    top: 2.75rem;
    z-index: 5;
    > p {
      font-family: 'Tomorrow';
      font-style: normal;
      font-weight: 500;
      font-size: .625rem;
      line-height: .75rem;
      text-align: center;
      letter-spacing: 0.05em;
      text-transform: uppercase;
      color: #053131;
      flex: none;
      order: 1;
      flex-grow: 0;
      > span {
        color: rgba(5, 49, 49, 0.8);
      }
    }
  }
  .ArmourText {
    position: absolute;
    left: 7.1rem;
    top: 4.7rem;
    z-index: 5;
    > p {
      font-family: 'Tomorrow';
      font-style: normal;
      font-weight: 500;
      font-size: .5rem;
      line-height: .625rem;      
      text-align: center;
      letter-spacing: 0.05em;
      text-transform: uppercase;      
      color: #2EFFFF;
      flex: none;
      order: 1;
      flex-grow: 0;
      > span {
        color: rgba(46, 255, 255, 0.4);
      }
    }
  }
  .Players {
    position: absolute;
    left: 9.1rem;
    top: .95rem;
    z-index: 5;
    > p {
      font-family: 'Tomorrow';
      font-style: normal;
      font-weight: 500;
      font-size: .625rem;
      line-height: .75rem;
      text-align: center;
      letter-spacing: 0.05em;
      text-transform: uppercase;      
      flex: none;
      order: 0;
      flex-grow: 0;
      color: #FCEE0C;
      text-shadow: 0px 0px .5rem #FCEE0C;
      > span {
        text-shadow: 0px 0px .5rem #fcec0c00;
        color: rgba(252, 238, 12, 0.4);
      }
    }
  }
  .Jobs {
    position: absolute;
    width:4.75rem;
    right:5.1rem;
    top: 1.2rem;
    z-index: 5;
    // background-color:red;
    > p {
      font-family: 'Tomorrow';
      font-style: normal;
      font-weight: 500;
      font-size: .625rem;
      line-height: .75rem;
      text-align: center;
      letter-spacing: 0.05em;
      text-transform: uppercase;
      color: #FCEE0C;
      filter: drop-shadow(0 0 .5rem #FCEE0C);
      // text-shadow: 0px 0px .5rem #FCEE0C;
    }
  }
`

const PlayerHud = () => {
  const { isArmour, isHealth, isID, isMaxPlayer, isOnlinePlayer, isGunAnim } = useContext(MainContext);
  return (
    <PlayerHudClass style={isGunAnim ? {animation: `ShotScales .3s ease-out forwards`} : {animation: ``}} left={true}>        
      <div className="Players"><p>{isOnlinePlayer}<span>/{isMaxPlayer}</span></p></div>
      <svg className="SVG" width="17.875rem" height="6.125rem" viewBox="0 0 286 98" fill="none" xmlns="http://www.w3.org/2000/svg">

        <path d="M242.749 73.0527H89.3359L97.9217 87.4927H245.796L249.922 84.9141L242.749 73.0527Z" fill="#053131" fill-opacity="0.8"/>
        <path d="M265.852 40.1416H21L45.9219 81H87.9219L78.9219 63.8644H276.793L279.372 61.8015L265.852 40.1416Z" fill="#053131" fill-opacity="0.8"/>
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
            <text fill="#FCEE0C" xmlSpace="preserve" style={{whiteSpace: 'pre'}} font-family="Tomorrow" font-size=".625rem" font-weight="500" letter-spacing="0.05em"><tspan x="78.2793" y="27">{isID}</tspan></text>
        </g>




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

      <div className="HealthText"><p>{isHealth}<span>/100</span></p></div>
      <div className="ArmourText"><p>{isArmour}<span>/100</span></p></div>
      <svg style={{position: 'absolute', left: '7.05rem', top:'3.2rem', zIndex:'4'}} width="10.688rem" height="1.125rem" viewBox="0 0 171 18" fill="none" xmlns="http://www.w3.org/2000/svg">
        <mask id="mask0_111_59" style={{maskType: 'alpha'}} maskUnits="userSpaceOnUse" x="0" y="0" width={isHealth+'%'} height="100%">
          <path d="M168 18L170.278 16L160.5 0L0 0L9.05546 18H168Z" fill="#053131" fill-opacity="0.8"/>
        </mask>
        <g mask="url(#mask0_111_59)">
          <path d="M167.726 18L170 16L160.238 0L0 0L9.04069 18H167.726Z" fill="#2EFFFF"/>
        </g>
      </svg>

      <svg style={{position: 'absolute', left: '5.3rem', top:'3.2rem'}} width="12.438rem" height="1.125rem" viewBox="0 0 199 18" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path fill-rule="evenodd" clip-rule="evenodd" d="M18 18L8.7953 0H0L9.21265 18H18ZM32 18L22.7953 0H14L23.2126 18H32ZM198.278 16L196 18H37.0555L28 0H188.5L198.278 16Z" fill="#2EFFFF" fill-opacity="0.4"/>
      </svg>

      <svg style={{position: 'absolute', left: '10.2rem', top:'5.25rem'}} width="5.75rem" height="0.563rem" viewBox="0 0 92 9" fill="none" xmlns="http://www.w3.org/2000/svg">
        <mask id="mask0_113_8" style={{maskType: 'alpha'}} maskUnits="userSpaceOnUse" x="0" y="0" width={isArmour+'%'} height="9">
          <path d="M91.1741 7L86.589 0L0 0L4.58901 9H88.1741L91.1741 7Z" fill="white"/>
        </mask>
        <g mask="url(#mask0_113_8)">
          <path d="M91.1741 7L86.589 0L0 0L4.58901 9H88.1741L91.1741 7Z" fill="white"/>
        </g>
      </svg>

      <svg style={{position: 'absolute', left: '9.32rem', top:'5.25rem'}} width="6.625rem" height="0.563rem" viewBox="0 0 106 9" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M8.92188 9L4.8309 0H0.921875L5.01638 9H8.92188Z" fill="white" fill-opacity="0.4"/>
        <path d="M15.9219 9L11.3195 0H6.92188L11.5282 9H15.9219Z" fill="white" fill-opacity="0.4"/>
        <path d="M105.085 7L100.5 0L13.911 0L18.5 9H102.085L105.085 7Z" fill="white" fill-opacity="0.4"/>
      </svg>
    </PlayerHudClass>
  )
}


const PlayerHudInfo = () => {
  const { isGunAnim, isMoney, isBankMoney, isJobName } = useContext(MainContext);
  return (
    <PlayerHudClass left={false}>
      <div className='Jobs'><p>{isJobName}</p></div>
      <svg style={isGunAnim ? {animation: `ShotScales .3s ease-out forwards`} : {animation: ``}} className='SVG' width="23.875rem" height="3.625rem" viewBox="0 0 382 58" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M204.5 26.5H9L21 55H331L354.5 40.5V14H319L307.5 43.5H223.5L204.5 26.5Z" fill="#053131" fill-opacity="0.8"/>
        <path d="M303.5 37.5L311.5 14H12L8.5 20H207.5L227 37.5H303.5Z" fill="#053131" fill-opacity="0.8"/>

        <path style={{filter:'drop-shadow(0 0 .5rem #2EFFFF)'}} d="M331.167 23V20.75C331.167 20.5511 331.254 20.3603 331.411 20.2197C331.567 20.079 331.779 20 332 20H338.667C338.888 20 339.1 20.079 339.256 20.2197C339.412 20.3603 339.5 20.5511 339.5 20.75V23H342.833C343.054 23 343.266 23.079 343.423 23.2197C343.579 23.3603 343.667 23.5511 343.667 23.75V34.25C343.667 34.4489 343.579 34.6397 343.423 34.7803C343.266 34.921 343.054 35 342.833 35H327.833C327.612 35 327.4 34.921 327.244 34.7803C327.088 34.6397 327 34.4489 327 34.25V23.75C327 23.5511 327.088 23.3603 327.244 23.2197C327.4 23.079 327.612 23 327.833 23H331.167ZM337.833 24.5H332.833V33.5H337.833V24.5ZM331.167 24.5H328.667V33.5H331.167V24.5ZM339.5 24.5V33.5H342V24.5H339.5ZM332.833 21.5V23H337.833V21.5H332.833Z" fill="#2EFFFF"/>

        <path style={{filter:'drop-shadow(0 0 .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M366 10.5C366 11.8807 364.881 13 363.5 13C362.291 13 361.282 12.1411 361.05 11H316.849L305.849 41H224.805L206.305 24H137.75L138.667 25.0386H88.4187L93.1212 30.3333H47.4169L41.8238 24H8V23H8.00032V21H135.1L136.867 23H206.695L225.195 40H305.151L316.151 10H361.05C361.282 8.85888 362.291 8 363.5 8C364.881 8 366 9.11929 366 10.5Z" fill="#2EFFFF"/>

        <path style={{filter:'drop-shadow(0 0 .5rem #2EFFFF)'}} d="M44 37.3333H46.25C46.4489 37.3333 46.6397 37.4211 46.7803 37.5774C46.921 37.7337 47 37.9457 47 38.1667V48.1667C47 48.3877 46.921 48.5996 46.7803 48.7559C46.6397 48.9122 46.4489 49 46.25 49H32.75C32.5511 49 32.3603 48.9122 32.2197 48.7559C32.079 48.5996 32 48.3877 32 48.1667V34.8333C32 34.6123 32.079 34.4004 32.2197 34.2441C32.3603 34.0878 32.5511 34 32.75 34H44V37.3333ZM33.5 39V47.3333H45.5V39H33.5ZM33.5 35.6667V37.3333H42.5V35.6667H33.5ZM41.75 42.3333H44V44H41.75V42.3333Z" fill="#2EFFFF"/>

        <text fill="#FCEE0C" xmlSpace='preserve' style={{whiteSpace: 'pre', filter:'drop-shadow(0 0 .5rem #FCEE0C)'}} font-family="Tomorrow" font-size=".625rem" font-weight="500" letter-spacing="0.05em"><tspan x="56.4434" y="46">$ {isMoney}</tspan></text>

        <path style={{filter:'drop-shadow(0 0 .5rem #2EFFFF)'}} d="M128 47.5H144.667V49H128V47.5ZM129.667 41.5H131.333V46.75H129.667V41.5ZM133.833 41.5H135.5V46.75H133.833V41.5ZM137.167 41.5H138.833V46.75H137.167V41.5ZM141.333 41.5H143V46.75H141.333V41.5ZM128 37.75L136.333 34L144.667 37.75V40.75H128V37.75ZM129.667 38.677V39.25H143V38.677L136.333 35.677L129.667 38.677ZM136.333 38.5C136.112 38.5 135.9 38.421 135.744 38.2803C135.588 38.1397 135.5 37.9489 135.5 37.75C135.5 37.5511 135.588 37.3603 135.744 37.2197C135.9 37.079 136.112 37 136.333 37C136.554 37 136.766 37.079 136.923 37.2197C137.079 37.3603 137.167 37.5511 137.167 37.75C137.167 37.9489 137.079 38.1397 136.923 38.2803C136.766 38.421 136.554 38.5 136.333 38.5Z" fill="#2EFFFF"/>

        <text fill="#FCEE0C" xmlSpace='preserve' style={{whiteSpace: 'pre', filter:'drop-shadow(0 0 .5rem #FCEE0C)'}} font-family="Tomorrow" font-size=".625rem" font-weight="500" letter-spacing="0.05em"><tspan x="152.063" y="46">$ {isBankMoney}</tspan></text>
      </svg>
    </PlayerHudClass>
  )
}


// ? Voice

const VoiceClass = styled.div`
  position: absolute;
  height: 3.55rem;
  width: 11.15rem;
  left: 0;
  right: 0;
  margin: auto auto !important;
  bottom: 0;
  // background-color: rgba(102, 51, 153, 0.13);
`

const Voice = () => {
  const { isVoice, isVoiceRange, isGunAnim } = useContext(MainContext);

  const Voice = (data) => {
    if (data === 1) {
        return (<>
          <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M46.6481 17C47.0061 17 47.2963 17.3444 47.2963 17.7692V31.2308C47.2963 31.6556 47.0061 32 46.6481 32C46.2902 32 46 31.6556 46 31.2308V17.7692C46 17.3444 46.2902 17 46.6481 17Z" fill="#2EFFFF"/>
          <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M49.8891 18.923C50.2471 18.923 50.5373 19.2674 50.5373 19.6922V29.3076C50.5373 29.7324 50.2471 30.0768 49.8891 30.0768C49.5312 30.0768 49.241 29.7324 49.241 29.3076V19.6922C49.241 19.2674 49.5312 18.923 49.8891 18.923Z" fill="#2EFFFF"/>
          <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M53.1293 18.923C53.4873 18.923 53.7775 19.2674 53.7775 19.6922V29.3076C53.7775 29.7324 53.4873 30.0768 53.1293 30.0768C52.7714 30.0768 52.4812 29.7324 52.4812 29.3076V19.6922C52.4812 19.2674 52.7714 18.923 53.1293 18.923Z" fill="#2EFFFF"/>
          <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M56.3703 18.923C56.7283 18.923 57.0185 19.2674 57.0185 19.6922V29.3076C57.0185 29.7324 56.7283 30.0768 56.3703 30.0768C56.0124 30.0768 55.7222 29.7324 55.7222 29.3076V19.6922C55.7222 19.2674 56.0124 18.923 56.3703 18.923Z" fill="#2EFFFF"/>
          <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M59.6113 17C59.9692 17 60.2594 17.3444 60.2594 17.7692V31.2308C60.2594 31.6556 59.9692 32 59.6113 32C59.2533 32 58.9631 31.6556 58.9631 31.2308V17.7692C58.9631 17.3444 59.2533 17 59.6113 17Z" fill="#2EFFFF"/>
          <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M62.8515 18.923C63.2095 18.923 63.4997 19.2674 63.4997 19.6922V29.3076C63.4997 29.7324 63.2095 30.0768 62.8515 30.0768C62.4936 30.0768 62.2034 29.7324 62.2034 29.3076V19.6922C62.2034 19.2674 62.4936 18.923 62.8515 18.923Z" fill="#2EFFFF"/>
          <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M66.0925 18.923C66.4504 18.923 66.7406 19.2674 66.7406 19.6922V29.3076C66.7406 29.7324 66.4504 30.0768 66.0925 30.0768C65.7345 30.0768 65.4443 29.7324 65.4443 29.3076V19.6922C65.4443 19.2674 65.7345 18.923 66.0925 18.923Z" fill="#2EFFFF"/>
          <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M69.3335 18.923C69.6914 18.923 69.9816 19.2674 69.9816 19.6922V29.3076C69.9816 29.7324 69.6914 30.0768 69.3335 30.0768C68.9755 30.0768 68.6853 29.7324 68.6853 29.3076V19.6922C68.6853 19.2674 68.9755 18.923 69.3335 18.923Z" fill="#2EFFFF"/>
          <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M72.5737 17C72.9316 17 73.2218 17.3444 73.2218 17.7692V31.2308C73.2218 31.6556 72.9316 32 72.5737 32C72.2157 32 71.9255 31.6556 71.9255 31.2308V17.7692C71.9255 17.3444 72.2157 17 72.5737 17Z" fill="#2EFFFF"/>
          <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M75.8147 18.923C76.1726 18.923 76.4628 19.2674 76.4628 19.6922V29.3076C76.4628 29.7324 76.1726 30.0768 75.8147 30.0768C75.4567 30.0768 75.1665 29.7324 75.1665 29.3076V19.6922C75.1665 19.2674 75.4567 18.923 75.8147 18.923Z" fill="#2EFFFF"/>
          <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M79.0556 18.923C79.4136 18.923 79.7038 19.2674 79.7038 19.6922V29.3076C79.7038 29.7324 79.4136 30.0768 79.0556 30.0768C78.6977 30.0768 78.4075 29.7324 78.4075 29.3076V19.6922C78.4075 19.2674 78.6977 18.923 79.0556 18.923Z" fill="#2EFFFF"/>
        
        
          <path style={{opacity:'0.4'}} fill-rule="evenodd" clip-rule="evenodd" d="M82.2959 18.923C82.6538 18.923 82.944 19.2674 82.944 19.6922V29.3076C82.944 29.7324 82.6538 30.0768 82.2959 30.0768C81.9379 30.0768 81.6477 29.7324 81.6477 29.3076V19.6922C81.6477 19.2674 81.9379 18.923 82.2959 18.923Z" fill="#2EFFFF" fill-opacity="0.4"/>
          <path style={{opacity:'0.4'}} fill-rule="evenodd" clip-rule="evenodd" d="M85.5368 17C85.8948 17 86.185 17.3444 86.185 17.7692V31.2308C86.185 31.6556 85.8948 32 85.5368 32C85.1789 32 84.8887 31.6556 84.8887 31.2308V17.7692C84.8887 17.3444 85.1789 17 85.5368 17Z" fill="#2EFFFF" fill-opacity="0.4"/>
          <path style={{opacity:'0.4'}} fill-rule="evenodd" clip-rule="evenodd" d="M88.7778 18.923C89.1357 18.923 89.4259 19.2674 89.4259 19.6922V29.3076C89.4259 29.7324 89.1357 30.0768 88.7778 30.0768C88.4198 30.0768 88.1296 29.7324 88.1296 29.3076V19.6922C88.1296 19.2674 88.4198 18.923 88.7778 18.923Z" fill="#2EFFFF" fill-opacity="0.4"/>
          <path style={{opacity:'0.4'}} fill-rule="evenodd" clip-rule="evenodd" d="M92.0188 18.923C92.3767 18.923 92.6669 19.2674 92.6669 19.6922V29.3076C92.6669 29.7324 92.3767 30.0768 92.0188 30.0768C91.6608 30.0768 91.3706 29.7324 91.3706 29.3076V19.6922C91.3706 19.2674 91.6608 18.923 92.0188 18.923Z" fill="#2EFFFF" fill-opacity="0.4"/>
          <path style={{opacity:'0.4'}} fill-rule="evenodd" clip-rule="evenodd" d="M95.259 18.923C95.617 18.923 95.9071 19.2674 95.9071 19.6922V29.3076C95.9071 29.7324 95.617 30.0768 95.259 30.0768C94.901 30.0768 94.6108 29.7324 94.6108 29.3076V19.6922C94.6108 19.2674 94.901 18.923 95.259 18.923Z" fill="#2EFFFF" fill-opacity="0.4"/>
          <path style={{opacity:'0.4'}} fill-rule="evenodd" clip-rule="evenodd" d="M98.5 17C98.8579 17 99.1481 17.3444 99.1481 17.7692V31.2308C99.1481 31.6556 98.8579 32 98.5 32C98.142 32 97.8518 31.6556 97.8518 31.2308V17.7692C97.8518 17.3444 98.142 17 98.5 17Z" fill="#2EFFFF" fill-opacity="0.4"/>
          <path style={{opacity:'0.4'}} fill-rule="evenodd" clip-rule="evenodd" d="M101.741 18.923C102.099 18.923 102.389 19.2674 102.389 19.6922V29.3076C102.389 29.7324 102.099 30.0768 101.741 30.0768C101.383 30.0768 101.093 29.7324 101.093 29.3076V19.6922C101.093 19.2674 101.383 18.923 101.741 18.923Z" fill="#2EFFFF" fill-opacity="0.4"/>
          <path style={{opacity:'0.4'}} fill-rule="evenodd" clip-rule="evenodd" d="M104.981 18.923C105.339 18.923 105.629 19.2674 105.629 19.6922V29.3076C105.629 29.7324 105.339 30.0768 104.981 30.0768C104.623 30.0768 104.333 29.7324 104.333 29.3076V19.6922C104.333 19.2674 104.623 18.923 104.981 18.923Z" fill="#2EFFFF" fill-opacity="0.4"/>
          <path style={{opacity:'0.4'}} fill-rule="evenodd" clip-rule="evenodd" d="M108.222 18.923C108.58 18.923 108.87 19.2674 108.87 19.6922V29.3076C108.87 29.7324 108.58 30.0768 108.222 30.0768C107.864 30.0768 107.574 29.7324 107.574 29.3076V19.6922C107.574 19.2674 107.864 18.923 108.222 18.923Z" fill="#2EFFFF" fill-opacity="0.4"/>
          <path style={{opacity:'0.4'}} fill-rule="evenodd" clip-rule="evenodd" d="M111.463 17C111.821 17 112.111 17.3444 112.111 17.7692V31.2308C112.111 31.6556 111.821 32 111.463 32C111.105 32 110.815 31.6556 110.815 31.2308V17.7692C110.815 17.3444 111.105 17 111.463 17Z" fill="#2EFFFF" fill-opacity="0.4"/>
          <path style={{opacity:'0.4'}} fill-rule="evenodd" clip-rule="evenodd" d="M114.704 18.923C115.062 18.923 115.352 19.2674 115.352 19.6922V29.3076C115.352 29.7324 115.062 30.0768 114.704 30.0768C114.346 30.0768 114.056 29.7324 114.056 29.3076V19.6922C114.056 19.2674 114.346 18.923 114.704 18.923Z" fill="#2EFFFF" fill-opacity="0.4"/>

        
          <path style={{opacity:'0.4'}} fill-rule="evenodd" clip-rule="evenodd" d="M117.944 18.923C118.302 18.923 118.592 19.2674 118.592 19.6922V29.3076C118.592 29.7324 118.302 30.0768 117.944 30.0768C117.586 30.0768 117.296 29.7324 117.296 29.3076V19.6922C117.296 19.2674 117.586 18.923 117.944 18.923Z" fill="#2EFFFF" fill-opacity="0.4"/>
          <path style={{opacity:'0.4'}} fill-rule="evenodd" clip-rule="evenodd" d="M121.185 18.923C121.543 18.923 121.833 19.2674 121.833 19.6922V29.3076C121.833 29.7324 121.543 30.0768 121.185 30.0768C120.827 30.0768 120.537 29.7324 120.537 29.3076V19.6922C120.537 19.2674 120.827 18.923 121.185 18.923Z" fill="#2EFFFF" fill-opacity="0.4"/>
          <path style={{opacity:'0.4'}} fill-rule="evenodd" clip-rule="evenodd" d="M124.426 17C124.784 17 125.074 17.3444 125.074 17.7692V31.2308C125.074 31.6556 124.784 32 124.426 32C124.068 32 123.778 31.6556 123.778 31.2308V17.7692C123.778 17.3444 124.068 17 124.426 17Z" fill="#2EFFFF" fill-opacity="0.4"/>
          <path style={{opacity:'0.4'}} fill-rule="evenodd" clip-rule="evenodd" d="M127.666 18.923C128.024 18.923 128.315 19.2674 128.315 19.6922V29.3076C128.315 29.7324 128.024 30.0768 127.666 30.0768C127.308 30.0768 127.018 29.7324 127.018 29.3076V19.6922C127.018 19.2674 127.308 18.923 127.666 18.923Z" fill="#2EFFFF" fill-opacity="0.4"/>
          <path style={{opacity:'0.4'}} fill-rule="evenodd" clip-rule="evenodd" d="M130.907 18.923C131.265 18.923 131.556 19.2674 131.556 19.6922V29.3076C131.556 29.7324 131.265 30.0768 130.907 30.0768C130.549 30.0768 130.259 29.7324 130.259 29.3076V19.6922C130.259 19.2674 130.549 18.923 130.907 18.923Z" fill="#2EFFFF" fill-opacity="0.4"/>
          <path style={{opacity:'0.4'}} fill-rule="evenodd" clip-rule="evenodd" d="M134.148 18.923C134.506 18.923 134.797 19.2674 134.797 19.6922V29.3076C134.797 29.7324 134.506 30.0768 134.148 30.0768C133.79 30.0768 133.5 29.7324 133.5 29.3076V19.6922C133.5 19.2674 133.79 18.923 134.148 18.923Z" fill="#2EFFFF" fill-opacity="0.4"/>
          <path style={{opacity:'0.4'}} fill-rule="evenodd" clip-rule="evenodd" d="M137.389 17C137.747 17 138.037 17.3444 138.037 17.7692V31.2308C138.037 31.6556 137.747 32 137.389 32C137.031 32 136.74 31.6556 136.74 31.2308V17.7692C136.74 17.3444 137.031 17 137.389 17Z" fill="#2EFFFF" fill-opacity="0.4"/>
          <path style={{opacity:'0.4'}} fill-rule="evenodd" clip-rule="evenodd" d="M140.63 18.923C140.988 18.923 141.278 19.2674 141.278 19.6922V29.3076C141.278 29.7324 140.988 30.0768 140.63 30.0768C140.272 30.0768 139.981 29.7324 139.981 29.3076V19.6922C139.981 19.2674 140.272 18.923 140.63 18.923Z" fill="#2EFFFF" fill-opacity="0.4"/>
          <path style={{opacity:'0.4'}} fill-rule="evenodd" clip-rule="evenodd" d="M143.871 18.923C144.229 18.923 144.519 19.2674 144.519 19.6922V29.3076C144.519 29.7324 144.229 30.0768 143.871 30.0768C143.513 30.0768 143.222 29.7324 143.222 29.3076V19.6922C143.222 19.2674 143.513 18.923 143.871 18.923Z" fill="#2EFFFF" fill-opacity="0.4"/>
          <path style={{opacity:'0.4'}} fill-rule="evenodd" clip-rule="evenodd" d="M147.112 18.923C147.469 18.923 147.76 19.2674 147.76 19.6922V29.3076C147.76 29.7324 147.469 30.0768 147.112 30.0768C146.754 30.0768 146.463 29.7324 146.463 29.3076V19.6922C146.463 19.2674 146.754 18.923 147.112 18.923Z" fill="#2EFFFF" fill-opacity="0.4"/>
          <path style={{opacity:'0.4'}} fill-rule="evenodd" clip-rule="evenodd" d="M150.352 17C150.71 17 151 17.3444 151 17.7692V31.2308C151 31.6556 150.71 32 150.352 32C149.994 32 149.704 31.6556 149.704 31.2308V17.7692C149.704 17.3444 149.994 17 150.352 17Z" fill="#2EFFFF" fill-opacity="0.4"/>
        </>)
    } else if (data === 2) {
      return (<>
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M46.6481 17C47.0061 17 47.2963 17.3444 47.2963 17.7692V31.2308C47.2963 31.6556 47.0061 32 46.6481 32C46.2902 32 46 31.6556 46 31.2308V17.7692C46 17.3444 46.2902 17 46.6481 17Z" fill="#2EFFFF"/>
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M49.8891 18.923C50.2471 18.923 50.5373 19.2674 50.5373 19.6922V29.3076C50.5373 29.7324 50.2471 30.0768 49.8891 30.0768C49.5312 30.0768 49.241 29.7324 49.241 29.3076V19.6922C49.241 19.2674 49.5312 18.923 49.8891 18.923Z" fill="#2EFFFF"/>
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M53.1293 18.923C53.4873 18.923 53.7775 19.2674 53.7775 19.6922V29.3076C53.7775 29.7324 53.4873 30.0768 53.1293 30.0768C52.7714 30.0768 52.4812 29.7324 52.4812 29.3076V19.6922C52.4812 19.2674 52.7714 18.923 53.1293 18.923Z" fill="#2EFFFF"/>
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M56.3703 18.923C56.7283 18.923 57.0185 19.2674 57.0185 19.6922V29.3076C57.0185 29.7324 56.7283 30.0768 56.3703 30.0768C56.0124 30.0768 55.7222 29.7324 55.7222 29.3076V19.6922C55.7222 19.2674 56.0124 18.923 56.3703 18.923Z" fill="#2EFFFF"/>
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M59.6113 17C59.9692 17 60.2594 17.3444 60.2594 17.7692V31.2308C60.2594 31.6556 59.9692 32 59.6113 32C59.2533 32 58.9631 31.6556 58.9631 31.2308V17.7692C58.9631 17.3444 59.2533 17 59.6113 17Z" fill="#2EFFFF"/>
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M62.8515 18.923C63.2095 18.923 63.4997 19.2674 63.4997 19.6922V29.3076C63.4997 29.7324 63.2095 30.0768 62.8515 30.0768C62.4936 30.0768 62.2034 29.7324 62.2034 29.3076V19.6922C62.2034 19.2674 62.4936 18.923 62.8515 18.923Z" fill="#2EFFFF"/>
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M66.0925 18.923C66.4504 18.923 66.7406 19.2674 66.7406 19.6922V29.3076C66.7406 29.7324 66.4504 30.0768 66.0925 30.0768C65.7345 30.0768 65.4443 29.7324 65.4443 29.3076V19.6922C65.4443 19.2674 65.7345 18.923 66.0925 18.923Z" fill="#2EFFFF"/>
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M69.3335 18.923C69.6914 18.923 69.9816 19.2674 69.9816 19.6922V29.3076C69.9816 29.7324 69.6914 30.0768 69.3335 30.0768C68.9755 30.0768 68.6853 29.7324 68.6853 29.3076V19.6922C68.6853 19.2674 68.9755 18.923 69.3335 18.923Z" fill="#2EFFFF"/>
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M72.5737 17C72.9316 17 73.2218 17.3444 73.2218 17.7692V31.2308C73.2218 31.6556 72.9316 32 72.5737 32C72.2157 32 71.9255 31.6556 71.9255 31.2308V17.7692C71.9255 17.3444 72.2157 17 72.5737 17Z" fill="#2EFFFF"/>
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M75.8147 18.923C76.1726 18.923 76.4628 19.2674 76.4628 19.6922V29.3076C76.4628 29.7324 76.1726 30.0768 75.8147 30.0768C75.4567 30.0768 75.1665 29.7324 75.1665 29.3076V19.6922C75.1665 19.2674 75.4567 18.923 75.8147 18.923Z" fill="#2EFFFF"/>
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M79.0556 18.923C79.4136 18.923 79.7038 19.2674 79.7038 19.6922V29.3076C79.7038 29.7324 79.4136 30.0768 79.0556 30.0768C78.6977 30.0768 78.4075 29.7324 78.4075 29.3076V19.6922C78.4075 19.2674 78.6977 18.923 79.0556 18.923Z" fill="#2EFFFF"/>
        
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M82.2959 18.923C82.6538 18.923 82.944 19.2674 82.944 19.6922V29.3076C82.944 29.7324 82.6538 30.0768 82.2959 30.0768C81.9379 30.0768 81.6477 29.7324 81.6477 29.3076V19.6922C81.6477 19.2674 81.9379 18.923 82.2959 18.923Z" fill="#2EFFFF"/>
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M85.5368 17C85.8948 17 86.185 17.3444 86.185 17.7692V31.2308C86.185 31.6556 85.8948 32 85.5368 32C85.1789 32 84.8887 31.6556 84.8887 31.2308V17.7692C84.8887 17.3444 85.1789 17 85.5368 17Z" fill="#2EFFFF"/>
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M88.7778 18.923C89.1357 18.923 89.4259 19.2674 89.4259 19.6922V29.3076C89.4259 29.7324 89.1357 30.0768 88.7778 30.0768C88.4198 30.0768 88.1296 29.7324 88.1296 29.3076V19.6922C88.1296 19.2674 88.4198 18.923 88.7778 18.923Z" fill="#2EFFFF"/>
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M92.0188 18.923C92.3767 18.923 92.6669 19.2674 92.6669 19.6922V29.3076C92.6669 29.7324 92.3767 30.0768 92.0188 30.0768C91.6608 30.0768 91.3706 29.7324 91.3706 29.3076V19.6922C91.3706 19.2674 91.6608 18.923 92.0188 18.923Z" fill="#2EFFFF"/>
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M95.259 18.923C95.617 18.923 95.9071 19.2674 95.9071 19.6922V29.3076C95.9071 29.7324 95.617 30.0768 95.259 30.0768C94.901 30.0768 94.6108 29.7324 94.6108 29.3076V19.6922C94.6108 19.2674 94.901 18.923 95.259 18.923Z" fill="#2EFFFF"/>
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M98.5 17C98.8579 17 99.1481 17.3444 99.1481 17.7692V31.2308C99.1481 31.6556 98.8579 32 98.5 32C98.142 32 97.8518 31.6556 97.8518 31.2308V17.7692C97.8518 17.3444 98.142 17 98.5 17Z" fill="#2EFFFF" />
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M101.741 18.923C102.099 18.923 102.389 19.2674 102.389 19.6922V29.3076C102.389 29.7324 102.099 30.0768 101.741 30.0768C101.383 30.0768 101.093 29.7324 101.093 29.3076V19.6922C101.093 19.2674 101.383 18.923 101.741 18.923Z" fill="#2EFFFF" />
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M104.981 18.923C105.339 18.923 105.629 19.2674 105.629 19.6922V29.3076C105.629 29.7324 105.339 30.0768 104.981 30.0768C104.623 30.0768 104.333 29.7324 104.333 29.3076V19.6922C104.333 19.2674 104.623 18.923 104.981 18.923Z" fill="#2EFFFF" />
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M108.222 18.923C108.58 18.923 108.87 19.2674 108.87 19.6922V29.3076C108.87 29.7324 108.58 30.0768 108.222 30.0768C107.864 30.0768 107.574 29.7324 107.574 29.3076V19.6922C107.574 19.2674 107.864 18.923 108.222 18.923Z" fill="#2EFFFF" />
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M111.463 17C111.821 17 112.111 17.3444 112.111 17.7692V31.2308C112.111 31.6556 111.821 32 111.463 32C111.105 32 110.815 31.6556 110.815 31.2308V17.7692C110.815 17.3444 111.105 17 111.463 17Z" fill="#2EFFFF" />
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M114.704 18.923C115.062 18.923 115.352 19.2674 115.352 19.6922V29.3076C115.352 29.7324 115.062 30.0768 114.704 30.0768C114.346 30.0768 114.056 29.7324 114.056 29.3076V19.6922C114.056 19.2674 114.346 18.923 114.704 18.923Z" fill="#2EFFFF" />
      
        <path style={{opacity:'0.4'}} fill-rule="evenodd" clip-rule="evenodd" d="M117.944 18.923C118.302 18.923 118.592 19.2674 118.592 19.6922V29.3076C118.592 29.7324 118.302 30.0768 117.944 30.0768C117.586 30.0768 117.296 29.7324 117.296 29.3076V19.6922C117.296 19.2674 117.586 18.923 117.944 18.923Z" fill="#2EFFFF" fill-opacity="0.4"/>
        <path style={{opacity:'0.4'}} fill-rule="evenodd" clip-rule="evenodd" d="M121.185 18.923C121.543 18.923 121.833 19.2674 121.833 19.6922V29.3076C121.833 29.7324 121.543 30.0768 121.185 30.0768C120.827 30.0768 120.537 29.7324 120.537 29.3076V19.6922C120.537 19.2674 120.827 18.923 121.185 18.923Z" fill="#2EFFFF" fill-opacity="0.4"/>
        <path style={{opacity:'0.4'}} fill-rule="evenodd" clip-rule="evenodd" d="M124.426 17C124.784 17 125.074 17.3444 125.074 17.7692V31.2308C125.074 31.6556 124.784 32 124.426 32C124.068 32 123.778 31.6556 123.778 31.2308V17.7692C123.778 17.3444 124.068 17 124.426 17Z" fill="#2EFFFF" fill-opacity="0.4"/>
        <path style={{opacity:'0.4'}} fill-rule="evenodd" clip-rule="evenodd" d="M127.666 18.923C128.024 18.923 128.315 19.2674 128.315 19.6922V29.3076C128.315 29.7324 128.024 30.0768 127.666 30.0768C127.308 30.0768 127.018 29.7324 127.018 29.3076V19.6922C127.018 19.2674 127.308 18.923 127.666 18.923Z" fill="#2EFFFF" fill-opacity="0.4"/>
        <path style={{opacity:'0.4'}} fill-rule="evenodd" clip-rule="evenodd" d="M130.907 18.923C131.265 18.923 131.556 19.2674 131.556 19.6922V29.3076C131.556 29.7324 131.265 30.0768 130.907 30.0768C130.549 30.0768 130.259 29.7324 130.259 29.3076V19.6922C130.259 19.2674 130.549 18.923 130.907 18.923Z" fill="#2EFFFF" fill-opacity="0.4"/>
        <path style={{opacity:'0.4'}} fill-rule="evenodd" clip-rule="evenodd" d="M134.148 18.923C134.506 18.923 134.797 19.2674 134.797 19.6922V29.3076C134.797 29.7324 134.506 30.0768 134.148 30.0768C133.79 30.0768 133.5 29.7324 133.5 29.3076V19.6922C133.5 19.2674 133.79 18.923 134.148 18.923Z" fill="#2EFFFF" fill-opacity="0.4"/>
        <path style={{opacity:'0.4'}} fill-rule="evenodd" clip-rule="evenodd" d="M137.389 17C137.747 17 138.037 17.3444 138.037 17.7692V31.2308C138.037 31.6556 137.747 32 137.389 32C137.031 32 136.74 31.6556 136.74 31.2308V17.7692C136.74 17.3444 137.031 17 137.389 17Z" fill="#2EFFFF" fill-opacity="0.4"/>
        <path style={{opacity:'0.4'}} fill-rule="evenodd" clip-rule="evenodd" d="M140.63 18.923C140.988 18.923 141.278 19.2674 141.278 19.6922V29.3076C141.278 29.7324 140.988 30.0768 140.63 30.0768C140.272 30.0768 139.981 29.7324 139.981 29.3076V19.6922C139.981 19.2674 140.272 18.923 140.63 18.923Z" fill="#2EFFFF" fill-opacity="0.4"/>
        <path style={{opacity:'0.4'}} fill-rule="evenodd" clip-rule="evenodd" d="M143.871 18.923C144.229 18.923 144.519 19.2674 144.519 19.6922V29.3076C144.519 29.7324 144.229 30.0768 143.871 30.0768C143.513 30.0768 143.222 29.7324 143.222 29.3076V19.6922C143.222 19.2674 143.513 18.923 143.871 18.923Z" fill="#2EFFFF" fill-opacity="0.4"/>
        <path style={{opacity:'0.4'}} fill-rule="evenodd" clip-rule="evenodd" d="M147.112 18.923C147.469 18.923 147.76 19.2674 147.76 19.6922V29.3076C147.76 29.7324 147.469 30.0768 147.112 30.0768C146.754 30.0768 146.463 29.7324 146.463 29.3076V19.6922C146.463 19.2674 146.754 18.923 147.112 18.923Z" fill="#2EFFFF" fill-opacity="0.4"/>
        <path style={{opacity:'0.4'}} fill-rule="evenodd" clip-rule="evenodd" d="M150.352 17C150.71 17 151 17.3444 151 17.7692V31.2308C151 31.6556 150.71 32 150.352 32C149.994 32 149.704 31.6556 149.704 31.2308V17.7692C149.704 17.3444 149.994 17 150.352 17Z" fill="#2EFFFF" fill-opacity="0.4"/>
      </>)
    } else if (data === 3) {
      return (<>
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M46.6481 17C47.0061 17 47.2963 17.3444 47.2963 17.7692V31.2308C47.2963 31.6556 47.0061 32 46.6481 32C46.2902 32 46 31.6556 46 31.2308V17.7692C46 17.3444 46.2902 17 46.6481 17Z" fill="#2EFFFF"/>
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M49.8891 18.923C50.2471 18.923 50.5373 19.2674 50.5373 19.6922V29.3076C50.5373 29.7324 50.2471 30.0768 49.8891 30.0768C49.5312 30.0768 49.241 29.7324 49.241 29.3076V19.6922C49.241 19.2674 49.5312 18.923 49.8891 18.923Z" fill="#2EFFFF"/>
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M53.1293 18.923C53.4873 18.923 53.7775 19.2674 53.7775 19.6922V29.3076C53.7775 29.7324 53.4873 30.0768 53.1293 30.0768C52.7714 30.0768 52.4812 29.7324 52.4812 29.3076V19.6922C52.4812 19.2674 52.7714 18.923 53.1293 18.923Z" fill="#2EFFFF"/>
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M56.3703 18.923C56.7283 18.923 57.0185 19.2674 57.0185 19.6922V29.3076C57.0185 29.7324 56.7283 30.0768 56.3703 30.0768C56.0124 30.0768 55.7222 29.7324 55.7222 29.3076V19.6922C55.7222 19.2674 56.0124 18.923 56.3703 18.923Z" fill="#2EFFFF"/>
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M59.6113 17C59.9692 17 60.2594 17.3444 60.2594 17.7692V31.2308C60.2594 31.6556 59.9692 32 59.6113 32C59.2533 32 58.9631 31.6556 58.9631 31.2308V17.7692C58.9631 17.3444 59.2533 17 59.6113 17Z" fill="#2EFFFF"/>
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M62.8515 18.923C63.2095 18.923 63.4997 19.2674 63.4997 19.6922V29.3076C63.4997 29.7324 63.2095 30.0768 62.8515 30.0768C62.4936 30.0768 62.2034 29.7324 62.2034 29.3076V19.6922C62.2034 19.2674 62.4936 18.923 62.8515 18.923Z" fill="#2EFFFF"/>
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M66.0925 18.923C66.4504 18.923 66.7406 19.2674 66.7406 19.6922V29.3076C66.7406 29.7324 66.4504 30.0768 66.0925 30.0768C65.7345 30.0768 65.4443 29.7324 65.4443 29.3076V19.6922C65.4443 19.2674 65.7345 18.923 66.0925 18.923Z" fill="#2EFFFF"/>
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M69.3335 18.923C69.6914 18.923 69.9816 19.2674 69.9816 19.6922V29.3076C69.9816 29.7324 69.6914 30.0768 69.3335 30.0768C68.9755 30.0768 68.6853 29.7324 68.6853 29.3076V19.6922C68.6853 19.2674 68.9755 18.923 69.3335 18.923Z" fill="#2EFFFF"/>
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M72.5737 17C72.9316 17 73.2218 17.3444 73.2218 17.7692V31.2308C73.2218 31.6556 72.9316 32 72.5737 32C72.2157 32 71.9255 31.6556 71.9255 31.2308V17.7692C71.9255 17.3444 72.2157 17 72.5737 17Z" fill="#2EFFFF"/>
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M75.8147 18.923C76.1726 18.923 76.4628 19.2674 76.4628 19.6922V29.3076C76.4628 29.7324 76.1726 30.0768 75.8147 30.0768C75.4567 30.0768 75.1665 29.7324 75.1665 29.3076V19.6922C75.1665 19.2674 75.4567 18.923 75.8147 18.923Z" fill="#2EFFFF"/>
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M79.0556 18.923C79.4136 18.923 79.7038 19.2674 79.7038 19.6922V29.3076C79.7038 29.7324 79.4136 30.0768 79.0556 30.0768C78.6977 30.0768 78.4075 29.7324 78.4075 29.3076V19.6922C78.4075 19.2674 78.6977 18.923 79.0556 18.923Z" fill="#2EFFFF"/>
        
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M82.2959 18.923C82.6538 18.923 82.944 19.2674 82.944 19.6922V29.3076C82.944 29.7324 82.6538 30.0768 82.2959 30.0768C81.9379 30.0768 81.6477 29.7324 81.6477 29.3076V19.6922C81.6477 19.2674 81.9379 18.923 82.2959 18.923Z" fill="#2EFFFF"/>
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M85.5368 17C85.8948 17 86.185 17.3444 86.185 17.7692V31.2308C86.185 31.6556 85.8948 32 85.5368 32C85.1789 32 84.8887 31.6556 84.8887 31.2308V17.7692C84.8887 17.3444 85.1789 17 85.5368 17Z" fill="#2EFFFF"/>
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M88.7778 18.923C89.1357 18.923 89.4259 19.2674 89.4259 19.6922V29.3076C89.4259 29.7324 89.1357 30.0768 88.7778 30.0768C88.4198 30.0768 88.1296 29.7324 88.1296 29.3076V19.6922C88.1296 19.2674 88.4198 18.923 88.7778 18.923Z" fill="#2EFFFF"/>
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M92.0188 18.923C92.3767 18.923 92.6669 19.2674 92.6669 19.6922V29.3076C92.6669 29.7324 92.3767 30.0768 92.0188 30.0768C91.6608 30.0768 91.3706 29.7324 91.3706 29.3076V19.6922C91.3706 19.2674 91.6608 18.923 92.0188 18.923Z" fill="#2EFFFF"/>
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M95.259 18.923C95.617 18.923 95.9071 19.2674 95.9071 19.6922V29.3076C95.9071 29.7324 95.617 30.0768 95.259 30.0768C94.901 30.0768 94.6108 29.7324 94.6108 29.3076V19.6922C94.6108 19.2674 94.901 18.923 95.259 18.923Z" fill="#2EFFFF" />
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M98.5 17C98.8579 17 99.1481 17.3444 99.1481 17.7692V31.2308C99.1481 31.6556 98.8579 32 98.5 32C98.142 32 97.8518 31.6556 97.8518 31.2308V17.7692C97.8518 17.3444 98.142 17 98.5 17Z" fill="#2EFFFF" />
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M101.741 18.923C102.099 18.923 102.389 19.2674 102.389 19.6922V29.3076C102.389 29.7324 102.099 30.0768 101.741 30.0768C101.383 30.0768 101.093 29.7324 101.093 29.3076V19.6922C101.093 19.2674 101.383 18.923 101.741 18.923Z" fill="#2EFFFF" />
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M104.981 18.923C105.339 18.923 105.629 19.2674 105.629 19.6922V29.3076C105.629 29.7324 105.339 30.0768 104.981 30.0768C104.623 30.0768 104.333 29.7324 104.333 29.3076V19.6922C104.333 19.2674 104.623 18.923 104.981 18.923Z" fill="#2EFFFF" />
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M108.222 18.923C108.58 18.923 108.87 19.2674 108.87 19.6922V29.3076C108.87 29.7324 108.58 30.0768 108.222 30.0768C107.864 30.0768 107.574 29.7324 107.574 29.3076V19.6922C107.574 19.2674 107.864 18.923 108.222 18.923Z" fill="#2EFFFF" />
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M111.463 17C111.821 17 112.111 17.3444 112.111 17.7692V31.2308C112.111 31.6556 111.821 32 111.463 32C111.105 32 110.815 31.6556 110.815 31.2308V17.7692C110.815 17.3444 111.105 17 111.463 17Z" fill="#2EFFFF" />
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M114.704 18.923C115.062 18.923 115.352 19.2674 115.352 19.6922V29.3076C115.352 29.7324 115.062 30.0768 114.704 30.0768C114.346 30.0768 114.056 29.7324 114.056 29.3076V19.6922C114.056 19.2674 114.346 18.923 114.704 18.923Z" fill="#2EFFFF" />
        
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M117.944 18.923C118.302 18.923 118.592 19.2674 118.592 19.6922V29.3076C118.592 29.7324 118.302 30.0768 117.944 30.0768C117.586 30.0768 117.296 29.7324 117.296 29.3076V19.6922C117.296 19.2674 117.586 18.923 117.944 18.923Z" fill="#2EFFFF" />
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M121.185 18.923C121.543 18.923 121.833 19.2674 121.833 19.6922V29.3076C121.833 29.7324 121.543 30.0768 121.185 30.0768C120.827 30.0768 120.537 29.7324 120.537 29.3076V19.6922C120.537 19.2674 120.827 18.923 121.185 18.923Z" fill="#2EFFFF" />
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M124.426 17C124.784 17 125.074 17.3444 125.074 17.7692V31.2308C125.074 31.6556 124.784 32 124.426 32C124.068 32 123.778 31.6556 123.778 31.2308V17.7692C123.778 17.3444 124.068 17 124.426 17Z" fill="#2EFFFF"/>
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M127.666 18.923C128.024 18.923 128.315 19.2674 128.315 19.6922V29.3076C128.315 29.7324 128.024 30.0768 127.666 30.0768C127.308 30.0768 127.018 29.7324 127.018 29.3076V19.6922C127.018 19.2674 127.308 18.923 127.666 18.923Z" fill="#2EFFFF" />
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M130.907 18.923C131.265 18.923 131.556 19.2674 131.556 19.6922V29.3076C131.556 29.7324 131.265 30.0768 130.907 30.0768C130.549 30.0768 130.259 29.7324 130.259 29.3076V19.6922C130.259 19.2674 130.549 18.923 130.907 18.923Z" fill="#2EFFFF" />
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M134.148 18.923C134.506 18.923 134.797 19.2674 134.797 19.6922V29.3076C134.797 29.7324 134.506 30.0768 134.148 30.0768C133.79 30.0768 133.5 29.7324 133.5 29.3076V19.6922C133.5 19.2674 133.79 18.923 134.148 18.923Z" fill="#2EFFFF"/>
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M137.389 17C137.747 17 138.037 17.3444 138.037 17.7692V31.2308C138.037 31.6556 137.747 32 137.389 32C137.031 32 136.74 31.6556 136.74 31.2308V17.7692C136.74 17.3444 137.031 17 137.389 17Z" fill="#2EFFFF"/>
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M140.63 18.923C140.988 18.923 141.278 19.2674 141.278 19.6922V29.3076C141.278 29.7324 140.988 30.0768 140.63 30.0768C140.272 30.0768 139.981 29.7324 139.981 29.3076V19.6922C139.981 19.2674 140.272 18.923 140.63 18.923Z" fill="#2EFFFF" />
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M143.871 18.923C144.229 18.923 144.519 19.2674 144.519 19.6922V29.3076C144.519 29.7324 144.229 30.0768 143.871 30.0768C143.513 30.0768 143.222 29.7324 143.222 29.3076V19.6922C143.222 19.2674 143.513 18.923 143.871 18.923Z" fill="#2EFFFF"/>
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M147.112 18.923C147.469 18.923 147.76 19.2674 147.76 19.6922V29.3076C147.76 29.7324 147.469 30.0768 147.112 30.0768C146.754 30.0768 146.463 29.7324 146.463 29.3076V19.6922C146.463 19.2674 146.754 18.923 147.112 18.923Z" fill="#2EFFFF"/>
        <path style={{filter:'drop-shadow(0px 0px .5rem #2EFFFF)'}} fill-rule="evenodd" clip-rule="evenodd" d="M150.352 17C150.71 17 151 17.3444 151 17.7692V31.2308C151 31.6556 150.71 32 150.352 32C149.994 32 149.704 31.6556 149.704 31.2308V17.7692C149.704 17.3444 149.994 17 150.352 17Z" fill="#2EFFFF"/>
      </>)
    }
  }
  return (
    <VoiceClass>

      <svg style={isGunAnim ? {animation: `ShotScales .3s ease-out forwards`} : {animation: ``}} width="11.125rem" height="3.063rem" viewBox="0 0 178 49" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M17 10.5H158L166 24.5L158 38.5H17L9 24.5L17 10.5Z" fill="#053131" fill-opacity="0.8"/>
        <g filter="url(#filter0_d_8_483)">
          <path fill-rule="evenodd" clip-rule="evenodd" d="M53.5001 8H15.207L8.06385 20.7557C7.92892 20.9966 8.01486 21.3013 8.2558 21.4363C8.49673 21.5712 8.80143 21.4852 8.93635 21.2443L15.7932 9H53.5001C53.7762 9 54.0001 8.77614 54.0001 8.5C54.0001 8.22386 53.7762 8 53.5001 8ZM166.429 19.2428C166.287 19.006 165.98 18.9293 165.743 19.0713C165.506 19.2134 165.429 19.5205 165.571 19.7573L168.422 24.5082L159.708 40.0001H118C117.724 40.0001 117.5 40.2239 117.5 40.5001C117.5 40.7762 117.724 41.0001 118 41.0001H160.292L169.578 24.492L166.429 19.2428Z" fill="#2EFFFF"/>
        </g>
        <path style={isVoice ? {filter:'drop-shadow(0px 0px .5rem #FCEE0C)', opacity:'100%'} : {filter:'drop-shadow(0 0 .313rem #fcec0c2a)', opacity:'60%'}} d="M30.0989 17.8636C29.5564 17.8636 29.0361 18.0791 28.6525 18.4627C28.2689 18.8463 28.0534 19.3666 28.0534 19.9091V22.6364C28.0534 23.1789 28.2689 23.6991 28.6525 24.0827C29.0361 24.4663 29.5564 24.6818 30.0989 24.6818C30.6414 24.6818 31.1616 24.4663 31.5452 24.0827C31.9288 23.6991 32.1443 23.1789 32.1443 22.6364V19.9091C32.1443 19.3666 31.9288 18.8463 31.5452 18.4627C31.1616 18.0791 30.6414 17.8636 30.0989 17.8636ZM30.0989 16.5C30.5466 16.5 30.9899 16.5882 31.4035 16.7595C31.8171 16.9308 32.1929 17.1819 32.5095 17.4985C32.826 17.8151 33.0771 18.1909 33.2485 18.6045C33.4198 19.0181 33.508 19.4614 33.508 19.9091V22.6364C33.508 23.5405 33.1488 24.4076 32.5095 25.047C31.8701 25.6863 31.003 26.0455 30.0989 26.0455C29.1947 26.0455 28.3276 25.6863 27.6883 25.047C27.0489 24.4076 26.6898 23.5405 26.6898 22.6364V19.9091C26.6898 19.0049 27.0489 18.1378 27.6883 17.4985C28.3276 16.8592 29.1947 16.5 30.0989 16.5V16.5ZM24 23.3182H25.3739C25.5391 24.4533 26.1074 25.4909 26.9749 26.2413C27.8425 26.9917 28.9511 27.4047 30.0982 27.4047C31.2452 27.4047 32.3539 26.9917 33.2214 26.2413C34.089 25.4909 34.6573 24.4533 34.8225 23.3182H36.197C36.042 24.7014 35.4216 25.9909 34.4374 26.9751C33.4533 27.9594 32.1639 28.58 30.7807 28.7352V31.5H29.417V28.7352C28.0337 28.5802 26.7442 27.9596 25.7599 26.9753C24.7756 25.9911 24.1551 24.7015 24 23.3182V23.3182Z" fill="#FCEE0C"/>
        {Voice(isVoiceRange)}
        <defs>
          <filter id="filter0_d_8_483" x="0" y="0" width="177.578" height="49.0001" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
            <feFlood flood-opacity="0" result="BackgroundImageFix"/>
            <feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>
            <feOffset/>
            <feGaussianBlur stdDeviation="4"/>
            <feComposite in2="hardAlpha" operator="out"/>
            <feColorMatrix type="matrix" values="0 0 0 0 0.180392 0 0 0 0 1 0 0 0 0 1 0 0 0 1 0"/>
            <feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow_8_483"/>
            <feBlend mode="normal" in="SourceGraphic" in2="effect1_dropShadow_8_483" result="shape"/>
          </filter>
        </defs>
      </svg>
    </VoiceClass>
  )
}


const MapClass = styled.div`
  position: absolute;
  bottom: .2rem;
  // left: 3.3rem;
  ${props => props.isMap ? `
    left: 3.3rem;
    opacity: 1;
  ` : `
    left: -9rem;
    opacity: 0;
  ` }
  .MapStreetName {
    position: absolute;
    height: 1.5rem;
    width: 14rem;
    bottom: 1.9rem;
    left: 3.1rem;
    z-index: 5;
    // background-color: rgba(102, 51, 153, 0.5);
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
    > p {
      font-family: 'Tomorrow';
      font-style: normal;
      font-weight: 500;
      font-size: .75rem;
      line-height: 0;
      text-align: center;
      letter-spacing: 0.05em;
      text-transform: uppercase;
      color: #053131;
      flex: none;
      order: 0;
      flex-grow: 0;
    }
  }
`

const Map = () => {
  const { isMap, isStreet } = useContext(MainContext);
  return (
    <MapClass isMap={isMap}>
      <div className='MapStreetName'><p>{isStreet}</p></div>
      <svg style={{filter: 'drop-shadow(0px 0px 8px rgba(46, 255, 255, 0.5))'}} width="18.438rem" height="14.375rem" viewBox="0 0 295 230" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M18.92 183.3L23.14 179.08V176.82L19 181C19 181 18.92 183.2 18.92 183.3Z" fill="#2EFFFF"/>
        <path d="M18.92 178.36L23.14 174.14V171.88L19 176C19 176 18.92 178.26 18.92 178.36Z" fill="#2EFFFF"/>
        <path d="M18.92 173.42L23.14 169.2V166.94L19 171.1C19 171.1 18.92 173.32 18.92 173.42Z" fill="#2EFFFF"/>
        <path d="M18.92 168.48L23.14 164.26V162L19 166.16C19 166.16 18.92 168.38 18.92 168.48Z" fill="#2EFFFF"/>
        <path d="M18.92 163.54L23.14 159.32V157.06L19 161.22C19 161.22 18.92 163.44 18.92 163.54Z" fill="#2EFFFF"/>
        <path d="M9.25 33.5601H8.87V48.1901H9.25V33.5601Z" fill="#2EFFFF"/>
          <path d="M283.14 167.47V52.67L281.38 50.92V34.47L283.66 32.2V14.42L279.91 10.67V10.61H279.84L279.65 10.42H209.25L206.59 13.08H89.59L84.55 8H20.23L8.6 19.62V31.3H9.48V20L11.55 17.92V51.86L9.26 54.15V50.34H8.88V54.53L8 55.41V67.46L11.55 71V166.17L8.55 169.17V186.38L11.55 189.38V207.18L26 216.35L29.62 211.56H42.67L47.29 207H85.5L83.11 199.89L85.4634 206.89L85.5 207H208L211.51 210.5H281.72L283.09 209.13V205.91L280.67 203.49V187L282.44 185.22V183.88H209.73L207.19 181.34H52.47L52.75 180.96H207.65L210.19 183.5H282.7V179.26H54.08H283.08V168.76L285.5 171.19V211.66L280.88 216.28H252.36V214.19L251.07 212.89H247.15L245.75 214.29V216.29H233.82V214.2L232.53 212.9H228.61L227.21 214.3V216.3H215.29V214.21L213.99 212.91H210.08L208.68 214.31V216.31H93.21V214.22L91.92 212.92H88L86.6 214.32V216.32H74.67V214.23L73.38 212.93H69.46L68.06 214.33V216.33H56.13V214.24L54.84 212.94H50.92L49.52 214.34V216.34H33.52L29.52 220.34H23L18.22 215.57L17.6 216.19L22.6 221.19H29.88L33.88 217.19H281.31L286.44 212.06V170.86L283.14 167.47ZM11.55 188.12L9.44 186V169.53L11.55 167.42V188.12ZM11.55 69.77L8.88 67.1V55.77L11.55 53.1V69.77ZM279.91 11.91L282.78 14.79V31.79L280.51 34.07V50L279.91 49.41V11.91ZM264.29 11.29L279 26V48.57L247.5 17.07L247.41 17H243.52L249.17 11.34L264.29 11.29ZM246.47 11.29L240.82 17H237.75L243.41 11.34L246.47 11.29ZM240.71 11.29L235.05 17H232L237.66 11.34L240.71 11.29ZM234.94 11.29L229.29 17H226.23L231.88 11.34L234.94 11.29ZM229.18 11.29L223.53 17H220.47L226.12 11.34L229.18 11.29ZM223.42 11.29L217.77 17H214.7L220.36 11.34L223.42 11.29ZM217.66 11.29L212 17H208.94L214.59 11.34L217.66 11.29ZM207 14L209.66 11.34H211.94L206.24 17H72.69L75.69 14H207ZM20.59 8.88H84.19L88.39 13.08H75.32L71.45 17H60.83V14.73L59.54 13.44H55.62L54.22 14.84V17H40.48V14.73L39.19 13.44H35.27L33.87 14.84V17H20H12.49L20.59 8.88ZM56.4 15.29V17H54.6V15L55.78 13.82H59.38L60.45 14.89V17H58.82V15.29H56.4ZM36.05 15.29V17H34.25V15L35.42 13.82H39L40.1 14.88V17H38.46V15.29H36.05ZM282.26 97.29L281 98.53V124.16L282.28 125.44V178.34H53.7L25.7 215.34L12.42 206.5V156.67L13.52 155.57V129.94L12.42 128.85V70.9L12.55 70.77L12.42 70.64V52.23L12.55 52.1L12.42 52V17.82H71.72H71.77H247.05L282.26 53V97.29ZM55.75 216.29H54.11V214.7H51.7V216.23H49.9V214.4L51.08 213.22H54.68L55.75 214.29V216.29ZM74.29 216.29H72.65V214.7H70.23V216.23H68.43V214.4L69.61 213.22H73.22L74.29 214.29V216.29ZM92.83 216.29H91.19V214.7H88.77V216.23H87V214.4L88.18 213.22H91.79L92.86 214.29L92.83 216.29ZM214.91 216.29H213.27V214.7H210.85V216.23H209.05V214.4L210.23 213.22H213.84L214.91 214.29V216.29ZM233.45 216.29H231.81V214.7H229.39V216.23H227.59V214.4L228.77 213.22H232.38L233.45 214.29V216.29ZM251.99 216.29H250.35V214.7H247.93V216.23H246.13V214.4L247.31 213.22H250.92L251.99 214.29V216.29Z" fill="#2EFFFF"/>

        <path d="M244.03 23.15H218.04V24.03H243.66L256.37 36.73L256.99 36.11L244.16 23.28L244.03 23.15Z" fill="#2EFFFF"/>
        <path d="M257.356 36.4776L256.733 37.0996L262.325 42.6948L262.947 42.0727L257.356 36.4776Z" fill="#2EFFFF"/>
        <path d="M264.03 44.55L264.64 43.93L263.24 42.53L262.63 43.15L264.03 44.55Z" fill="#2EFFFF"/>
      </svg>
    </MapClass>
  )
}




// const mapStateToProps = (state) => ({})