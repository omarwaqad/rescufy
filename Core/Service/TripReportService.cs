using Domain.Contracts;
using Domain.Models;
using ServiceAbstraction;
using Shared.DTOs.TripReport;
using Shared.Enums;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace Service
{
    public class TripReportService(IUnitOfWork unitOfWork, INotificationRealTimeSender notificationRealTimeSender) : ITripReportService
    {
        public async Task<TripReportDto> CreateTripReportAsync(CreateTripReportDto dto)
        {
            // Check if Request exists and is Finished
            var request = await unitOfWork.GetRepository<Request, int>().GetByIdAsync(dto.RequestId);
            if (request == null) throw new Exception("Request not found");
            
            if (request.RequestStatus != RequestStatus.Finished)
                throw new Exception("Reports can only be added to Finished requests");

            // Check if TripReport already exists for this Request to prevent duplicates
            var existingReports = await unitOfWork.GetRepository<TripReport, int>()
                .GetAllAsync(predicate: tr => tr.RequestId == dto.RequestId);
            if (existingReports.Any())
                throw new Exception("Trip Report already exists for this request");

            // Create Entity
            var tripReport = new TripReport
            {
                RequestId = dto.RequestId,
                PatientId = request.UserId, // Get patient from request
                HospitalId = dto.HospitalId,
                MedicalProcedures = dto.MedicalProcedures,
                AdmissionTime = dto.AdmissionTime,
                DischargeTime = dto.DischargeTime,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            };

            await unitOfWork.GetRepository<TripReport, int>().AddAsync(tripReport);
            await unitOfWork.SaveChangesAsync();

            // Broadast specific and generic events
            await notificationRealTimeSender.BroadcastReportAddedAsync(dto.RequestId, tripReport.Id);
            await notificationRealTimeSender.BroadcastRequestUpdatedAsync(dto.RequestId, "ReportAdded", new { TripReportId = tripReport.Id });

            return await GetTripReportByIdAsync(tripReport.Id);
        }

        public async Task<TripReportDto> UpdateTripReportAsync(int id, UpdateTripReportDto dto)
        {
            var tripReport = await unitOfWork.GetRepository<TripReport, int>().GetByIdAsync(id);
            if (tripReport == null) throw new Exception("Trip Report not found");

            tripReport.MedicalProcedures = dto.MedicalProcedures;
            tripReport.AdmissionTime = dto.AdmissionTime;
            tripReport.DischargeTime = dto.DischargeTime;
            tripReport.UpdatedAt = DateTime.UtcNow;

            unitOfWork.GetRepository<TripReport, int>().Update(tripReport);
            await unitOfWork.SaveChangesAsync();

            return await GetTripReportByIdAsync(id);
        }

        public async Task<TripReportDto> GetTripReportByRequestIdAsync(int requestId)
        {
            var reports = await unitOfWork.GetRepository<TripReport, int>()
                .GetAllAsync(
                    predicate: tr => tr.RequestId == requestId,
                    includes: [tr => tr.Patient, tr => tr.Hospital]
                );

            var report = reports.FirstOrDefault();
            if (report == null) throw new Exception("Trip Report not found for this request");

            return MapToDto(report);
        }

        private async Task<TripReportDto> GetTripReportByIdAsync(int id)
        {
            var reports = await unitOfWork.GetRepository<TripReport, int>()
                .GetAllAsync(
                    predicate: tr => tr.Id == id,
                    includes: [tr => tr.Patient, tr => tr.Hospital]
                );

            var report = reports.FirstOrDefault();
            if (report == null) throw new Exception("Trip Report not found");

            return MapToDto(report);
        }

        private TripReportDto MapToDto(TripReport report)
        {
            return new TripReportDto
            {
                Id = report.Id,
                RequestId = report.RequestId,
                PatientId = report.PatientId,
                PatientName = report.Patient?.Name ?? "",
                PatientAge = report.Patient?.Age ?? 0,
                PatientNationalId = report.Patient?.NationalId ?? "",
                HospitalId = report.HospitalId,
                HospitalName = report.Hospital?.Name ?? "",
                MedicalProcedures = report.MedicalProcedures,
                AdmissionTime = report.AdmissionTime,
                DischargeTime = report.DischargeTime,
                CreatedAt = report.CreatedAt,
                UpdatedAt = report.UpdatedAt
            };
        }
    }
}
