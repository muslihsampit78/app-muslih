<?php

namespace App\Filament\Resources\Questions\Tables;

use App\Enums\QuestionStatus;
use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Filters\SelectFilter;
use Filament\Tables\Table;

class QuestionsTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('created_at')
                    ->label('Tanggal Masuk')
                    ->dateTime('d M Y H:i')
                    ->sortable(),
                TextColumn::make('subject')
                    ->label('Subjek Pertanyaan')
                    ->searchable()
                    ->sortable()
                    ->limit(40)
                    ->description(fn ($record): string => $record->name.' ('.$record->email.')'),
                TextColumn::make('topic.name')
                    ->label('Topik')
                    ->badge()
                    ->color('info')
                    ->sortable()
                    ->searchable(),
                TextColumn::make('status')
                    ->label('Status')
                    ->badge()
                    ->formatStateUsing(fn ($state) => $state instanceof QuestionStatus ? $state->label() : QuestionStatus::tryFrom($state)?->label() ?? $state)
                    ->color(fn ($state) => match ($state instanceof QuestionStatus ? $state : QuestionStatus::tryFrom($state)) {
                        QuestionStatus::Answered => 'success',
                        QuestionStatus::Rejected => 'danger',
                        default => 'warning',
                    })
                    ->sortable(),
                TextColumn::make('answers_count')
                    ->label('Tanggapan')
                    ->counts('answers')
                    ->badge()
                    ->color('gray')
                    ->sortable(),
            ])
            ->defaultSort('created_at', 'desc')
            ->filters([
                SelectFilter::make('status')
                    ->label('Filter Status')
                    ->options(collect(QuestionStatus::cases())->mapWithKeys(fn (QuestionStatus $s) => [$s->value => $s->label()])),
                SelectFilter::make('topic_id')
                    ->label('Filter Topik')
                    ->relationship('topic', 'name'),
            ])
            ->recordActions([
                EditAction::make()->label('Buka & Tanggapi'),
            ])
            ->toolbarActions([
                BulkActionGroup::make([
                    DeleteBulkAction::make(),
                ]),
            ]);
    }
}
