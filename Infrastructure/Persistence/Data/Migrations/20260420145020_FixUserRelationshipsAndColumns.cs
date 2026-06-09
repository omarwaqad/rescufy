using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Persistence.Data.Migrations
{
    /// <inheritdoc />
    public partial class FixUserRelationshipsAndColumns : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Ambulances_AspNetUsers_DriverId",
                table: "Ambulances");

            migrationBuilder.AddColumn<int>(
                name: "AmbulanceId",
                table: "Requests",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "ArrivedAt",
                table: "Requests",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "AssignedAt",
                table: "Requests",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "CompletedAt",
                table: "Requests",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "DriverId",
                table: "Requests",
                type: "nvarchar(450)",
                nullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "EstimatedArrivalTime",
                table: "Requests",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "HospitalId",
                table: "Requests",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsAdminIntervention",
                table: "Requests",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<int>(
                name: "AcceptedRequests",
                table: "Hospitals",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<decimal>(
                name: "BasePrice",
                table: "Hospitals",
                type: "decimal(18,2)",
                nullable: false,
                defaultValue: 0m);

            migrationBuilder.AddColumn<int>(
                name: "TotalRequests",
                table: "Hospitals",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "Rate",
                table: "Feedbacks",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<string>(
                name: "TargetId",
                table: "Feedbacks",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<int>(
                name: "TargetType",
                table: "Feedbacks",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "AssignedAmbulanceId",
                table: "AspNetUsers",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "FullName",
                table: "AspNetUsers",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "ParamedicId",
                table: "Ambulances",
                type: "nvarchar(450)",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Requests_AmbulanceId",
                table: "Requests",
                column: "AmbulanceId");

            migrationBuilder.CreateIndex(
                name: "IX_Requests_DriverId",
                table: "Requests",
                column: "DriverId");

            migrationBuilder.CreateIndex(
                name: "IX_Requests_HospitalId",
                table: "Requests",
                column: "HospitalId");

            migrationBuilder.CreateIndex(
                name: "IX_AspNetUsers_AssignedAmbulanceId",
                table: "AspNetUsers",
                column: "AssignedAmbulanceId");

            migrationBuilder.CreateIndex(
                name: "IX_Ambulances_ParamedicId",
                table: "Ambulances",
                column: "ParamedicId");

            migrationBuilder.AddForeignKey(
                name: "FK_Ambulances_AspNetUsers_DriverId",
                table: "Ambulances",
                column: "DriverId",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Ambulances_AspNetUsers_ParamedicId",
                table: "Ambulances",
                column: "ParamedicId",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_AspNetUsers_Ambulances_AssignedAmbulanceId",
                table: "AspNetUsers",
                column: "AssignedAmbulanceId",
                principalTable: "Ambulances",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);

            migrationBuilder.AddForeignKey(
                name: "FK_Requests_Ambulances_AmbulanceId",
                table: "Requests",
                column: "AmbulanceId",
                principalTable: "Ambulances",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);

            migrationBuilder.AddForeignKey(
                name: "FK_Requests_AspNetUsers_DriverId",
                table: "Requests",
                column: "DriverId",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);

            migrationBuilder.AddForeignKey(
                name: "FK_Requests_Hospitals_HospitalId",
                table: "Requests",
                column: "HospitalId",
                principalTable: "Hospitals",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Ambulances_AspNetUsers_DriverId",
                table: "Ambulances");

            migrationBuilder.DropForeignKey(
                name: "FK_Ambulances_AspNetUsers_ParamedicId",
                table: "Ambulances");

            migrationBuilder.DropForeignKey(
                name: "FK_AspNetUsers_Ambulances_AssignedAmbulanceId",
                table: "AspNetUsers");

            migrationBuilder.DropForeignKey(
                name: "FK_Requests_Ambulances_AmbulanceId",
                table: "Requests");

            migrationBuilder.DropForeignKey(
                name: "FK_Requests_AspNetUsers_DriverId",
                table: "Requests");

            migrationBuilder.DropForeignKey(
                name: "FK_Requests_Hospitals_HospitalId",
                table: "Requests");

            migrationBuilder.DropIndex(
                name: "IX_Requests_AmbulanceId",
                table: "Requests");

            migrationBuilder.DropIndex(
                name: "IX_Requests_DriverId",
                table: "Requests");

            migrationBuilder.DropIndex(
                name: "IX_Requests_HospitalId",
                table: "Requests");

            migrationBuilder.DropIndex(
                name: "IX_AspNetUsers_AssignedAmbulanceId",
                table: "AspNetUsers");

            migrationBuilder.DropIndex(
                name: "IX_Ambulances_ParamedicId",
                table: "Ambulances");

            migrationBuilder.DropColumn(
                name: "AmbulanceId",
                table: "Requests");

            migrationBuilder.DropColumn(
                name: "ArrivedAt",
                table: "Requests");

            migrationBuilder.DropColumn(
                name: "AssignedAt",
                table: "Requests");

            migrationBuilder.DropColumn(
                name: "CompletedAt",
                table: "Requests");

            migrationBuilder.DropColumn(
                name: "DriverId",
                table: "Requests");

            migrationBuilder.DropColumn(
                name: "EstimatedArrivalTime",
                table: "Requests");

            migrationBuilder.DropColumn(
                name: "HospitalId",
                table: "Requests");

            migrationBuilder.DropColumn(
                name: "IsAdminIntervention",
                table: "Requests");

            migrationBuilder.DropColumn(
                name: "AcceptedRequests",
                table: "Hospitals");

            migrationBuilder.DropColumn(
                name: "BasePrice",
                table: "Hospitals");

            migrationBuilder.DropColumn(
                name: "TotalRequests",
                table: "Hospitals");

            migrationBuilder.DropColumn(
                name: "Rate",
                table: "Feedbacks");

            migrationBuilder.DropColumn(
                name: "TargetId",
                table: "Feedbacks");

            migrationBuilder.DropColumn(
                name: "TargetType",
                table: "Feedbacks");

            migrationBuilder.DropColumn(
                name: "AssignedAmbulanceId",
                table: "AspNetUsers");

            migrationBuilder.DropColumn(
                name: "FullName",
                table: "AspNetUsers");

            migrationBuilder.DropColumn(
                name: "ParamedicId",
                table: "Ambulances");

            migrationBuilder.AddForeignKey(
                name: "FK_Ambulances_AspNetUsers_DriverId",
                table: "Ambulances",
                column: "DriverId",
                principalTable: "AspNetUsers",
                principalColumn: "Id");
        }
    }
}
