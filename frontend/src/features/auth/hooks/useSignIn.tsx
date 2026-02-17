import { useAuth } from '@/app/provider/AuthContext';
import axios from 'axios';
import { useTranslation } from "react-i18next";
import  { useState } from 'react'
import { useNavigate } from 'react-router-dom';
import type { JwtPayload } from '../types/auth.types';
import { jwtDecode } from 'jwt-decode';
import { toast } from 'sonner';
import { useFormik } from 'formik';
import * as yup from 'yup';
import { useLanguage } from '@/i18n/useLanguage';

export default function useSignIn() {


     const navigate = useNavigate();
  const { setUser } = useAuth();
  const { t } = useTranslation(["auth", "validation"]);
  const { isRTL } = useLanguage();
  const [isLoading, setIsLoading] = useState(false);

  type SignInFormValues = {
    email: string;
    password: string;
  };

  async function handleSubmit(values: SignInFormValues) {
    setIsLoading(true);
    try {
      const { data } = await axios.post(
        "http://rescufyy.runasp.net/api/Auth/login",
        values,
        {
          headers: {
            "Content-Type": "application/json",
          },
        },
      );

      console.log(data);

      const decoded = jwtDecode<JwtPayload>(data.token);
      console.log(decoded);



      if (decoded.Role) {
        // Store the token
        localStorage.setItem("auth_token", data.token);

        // Store user data in context
        setUser({
          "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier":
            decoded[
              "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"
            ],
          "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name":
            decoded[
              "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"
            ],
          FullName: decoded.FullName,
          PicUrl: decoded.PicUrl,
          Email: decoded.Email,
          UserName: decoded.UserName,
          Role: decoded.Role.toLowerCase() as
            | "admin"
            | "hospital"
            | "ambulance",
          SecurityStamp: decoded.SecurityStamp,
          aud: decoded.aud,
          exp: decoded.exp,
          iss: decoded.iss,
          jti: decoded.jti,
        });

        toast.success(t("auth:signIn.success"), { 
          position: isRTL ? "top-left" : "top-right",
        });

        // Navigate based on role
        const roleRoute =
          decoded.Role.toLowerCase() === "admin"
            ? "/admin"
            : `/${decoded.Role.toLowerCase()}_user`;
        navigate(roleRoute);
      } else {
        toast.error(t("auth:signIn.roleNotFound"), {
          position: isRTL ? "top-left" : "top-right",
        });
        console.error("Role claim not found in token");
      }
    } catch (error: any) {
      console.error("Login error:", error);

      // Handle different error scenarios
      const toastPosition = isRTL ? "top-left" : "top-right";
      const toastDir = isRTL ? "rtl" : "ltr";
      
      if (error.response?.status === 401) {
        toast.error(t("auth:signIn.invalidCredentials"), {
          position: toastPosition,
        });
      } else if (error.response?.status === 400) {
        const errorMessage =
          error.response?.data?.message ||
          t("auth:signIn.badRequest");
        toast.error(errorMessage, {
          position: toastPosition,
        });
      } else if (error.response?.status === 429) {
        toast.error(t("auth:signIn.tooManyAttempts"), {
          position: toastPosition,
        });
      } else if (error.message === "Network Error") {
        toast.error(t("auth:signIn.networkError"), {
          position: toastPosition,
        });
      } else if (error.code === "ECONNABORTED") {
        toast.error(t("auth:signIn.timeout"), {
          position: toastPosition,
        });
      } else {
        toast.error(
          error.response?.data?.message ||
            t("auth:signIn.genericError"),
          {
            position: toastPosition,
          },
        );
      }
    } finally {
      setIsLoading(false);
    }
  }

  const validationSchema = yup.object({
    email: yup 
      .string()
      .email(t("validation:email.invalid"))
      .required(t("validation:email.required")),
    password: yup
      .string()
      .min(6, t("validation:password.minLength", { min: 6 }))
      .required(t("validation:password.required")),
  });

  const formik = useFormik({
    initialValues: {
      email: "",
      password: "",
    },
    onSubmit: handleSubmit,
    validationSchema: validationSchema,
  });

    return {
        formik,
        isLoading,
    };
  
}
