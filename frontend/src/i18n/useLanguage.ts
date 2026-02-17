/**
 * useLanguage Hook
 * Custom hook for managing language state and RTL direction
 */

import { useCallback, useEffect } from 'react';
import { useTranslation } from 'react-i18next';
import {
    LANGUAGE_CONFIG,
    LANGUAGE_STORAGE_KEY,
    type SupportedLanguage
} from './config';

export function useLanguage() {
    const { i18n } = useTranslation();

    const currentLanguage = i18n.language as SupportedLanguage;
    const languageConfig = LANGUAGE_CONFIG[currentLanguage] || LANGUAGE_CONFIG.en;
    const isRTL = languageConfig.dir === 'rtl';

    // Update document direction and language when language changes
    useEffect(() => {
        const config = LANGUAGE_CONFIG[currentLanguage] || LANGUAGE_CONFIG.en;
        document.documentElement.dir = config.dir;
        document.documentElement.lang = currentLanguage;
    }, [currentLanguage]);

    // Change language function
    const changeLanguage = useCallback(async (language: SupportedLanguage) => {
        try {
            await i18n.changeLanguage(language);
            localStorage.setItem(LANGUAGE_STORAGE_KEY, language);

            // Update document direction immediately
            const config = LANGUAGE_CONFIG[language];
            document.documentElement.dir = config.dir;
            document.documentElement.lang = language;
        } catch (error) {
            console.error('Failed to change language:', error);
        }
    }, [i18n]);

    // Toggle between English and Arabic
    const toggleLanguage = useCallback(() => {
        const newLanguage: SupportedLanguage = currentLanguage === 'en' ? 'ar' : 'en';
        changeLanguage(newLanguage);
    }, [currentLanguage, changeLanguage]);

    return {
        language: currentLanguage,
        languageConfig,
        isRTL,
        changeLanguage,
        toggleLanguage,
        supportedLanguages: LANGUAGE_CONFIG
    };
}

export default useLanguage;
