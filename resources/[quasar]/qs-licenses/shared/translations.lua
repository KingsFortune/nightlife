Config = Config or {}

Config.Language = 'en'

Config.Languages = {
    ['en'] = {
        ['LICENSES_PROGRESS'] = 'Getting licensed...',
        ['LICENSES_SUCCESS'] = 'Thanks for waiting, here is your new',
        ['LICENSES_NO_MONEY'] = "You don't have enough money",
        ['LICENSES_WOMEN_LABEL'] = 'Female',
        ['LICENSES_MAN_LABEL'] = 'Man',

        ['LICENSES_DIALOG_HEADER'] = 'Do you want to buy this license?',
        ['LICENSES_DIALOG_CONTENT'] = 'This license will cost you ${price} and will take {timer} seconds to complete.',
    },

    ['es'] = {
        ['LICENSES_PROGRESS'] = 'Obteniendo licencia...',
        ['LICENSES_SUCCESS'] = 'Gracias por esperar, aquí tienes tu nueva',
        ['LICENSES_NO_MONEY'] = 'No tienes dinero suficiente',
        ['LICENSES_WOMEN_LABEL'] = 'Mujer',
        ['LICENSES_MAN_LABEL'] = 'Hombre',

        ['LICENSES_DIALOG_HEADER'] = '¿Quieres comprar esta licencia?',
        ['LICENSES_DIALOG_CONTENT'] = 'Esta licencia costará ${price} y tardará {timer} segundos en completarse.',
    },
}
