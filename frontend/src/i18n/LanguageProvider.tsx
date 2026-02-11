/**
 * Language Provider Component
 * Wraps the app and manages language/RTL state
 */

import { useEffect, type ReactNode } from 'react';
import { I18nextProvider } from 'react-i18next';
import i18n from './index';
import { LANGUAGE_CONFIG, LANGUAGE_STORAGE_KEY, type SupportedLanguage } from './config';

interface LanguageProviderProps {
    children: ReactNode;
}

export function LanguageProvider({ children }: LanguageProviderProps) {
    // Initialize document direction and language on mount
    useEffect(() => {
        const savedLanguage = localStorage.getItem(LANGUAGE_STORAGE_KEY) as SupportedLanguage | null;
        const currentLang = savedLanguage || i18n.language as SupportedLanguage;
        const config = LANGUAGE_CONFIG[currentLang] || LANGUAGE_CONFIG.en;

        document.documentElement.dir = config.dir;
        document.documentElement.lang = currentLang;
    }, []);

    return (
        <I18nextProvider i18n={i18n}>
            {children}
        </I18nextProvider>
    );
}

export default LanguageProvider;
